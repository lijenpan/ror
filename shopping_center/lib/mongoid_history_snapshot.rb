module Mongoid::History
  module Snapshot
    extend ActiveSupport::Concern

    included do
      cattr_accessor :snapshotable_config
      self.snapshotable_config = []

      klass = self
      snapshot_klass = (self.to_s + "Snapshot")
      unless Object.const_defined?(snapshot_klass)
        Object.const_set(snapshot_klass, Class.new {
          def create_method(name, &block)
            self.class.send(:define_method, name, &block)
          end

        def create_attr(name)
          create_method("#{name}=".to_sym) do |val|
            instance_variable_set("@" + name, val)
          end

          create_method(name.to_sym) do
            instance_variable_get("@" + name)
          end
        end
        })
      end
    end

    module ClassMethods
      def snapshotable *args
        self.snapshotable_config = [] if self.snapshotable_config.nil?
        self.snapshotable_config = (self.snapshotable_config + args).uniq
      end

      def snapshot_class_name
        return "#{self.name}Snapshot"
      end
    end

    def snapshot dt
      mod = self

      tracks = history_tracks.where(:updated_at => {"$lte" => dt})
      versions = tracks.sort{|v1, v2| v1.created_at <=> v2.created_at}
      versions.each do |v|
        if(v.trackable.class == self.class)
          attrs = v.redo_attr("user")
          mod.attributes = attrs
          mod.version = v.version
          mod.updated_at = v.updated_at
        end
      end

      #for each attribute add it to snapshot
      s = Object.const_get(self.class.snapshot_class_name).new
      mod.attributes.select{|k,v| k != "_id"}.select{|k,v| !self.relations.keys.include? k}.each do |k,v|
        s.create_attr(k)
        s.send("#{k}=", v)
      end

      # for each relation add snapshot of that relation to ret
      self.snapshotable_config.each do |relation|
        r = mod.relations[relation.to_s]

        children = [].tap do |child|
          Array.wrap(mod.send(r.name)).each do |e|
            if(e.created_at <= dt)
              snap = e.snapshot(dt)
              child << snap if not snap.nil?
            end
          end
        end

        rhs = case r.macro
              when :embeds_many
                children
              when :embeds_one
                children.first
              end

        s.create_attr(r.key)
        s.send("#{r.key}=", rhs)
      end

      #find any destroyed history tracks
      destroy_tracks = history_tracks.where(action: "destroy")

      unless destroy_tracks.empty?
        #find associated tracks based on the last id in the association chain
        destroyed_track_ids = destroy_tracks.collect{|ht| ht.association_chain.last["id"]}

        #get all associated tracks each destroyed object, before given time limimt
        destroyed_children = tracks.group_by{|ht| ht.association_chain.last["id"]}.select{|k,v| destroyed_track_ids.include? k}

        #apply them to appropriate relations
        # 1. make a new snapshot of appropriate class
        destroyed_children.each do |k,v|
          relation = v.first.association_chain.last["name"]
          destroyed_snapshot = snapshot_from_tracks(v)
          if destroyed_snapshot
            if(self.relations[relation].macro == :embeds_many)
              s.send(relation).push(destroyed_snapshot)
            elsif(self.relations[relation].macro == :embeds_one)
              s.send("#{relation}=", destroyed_snapshot)
            end
          end
        end
      end

      s
    end

    private
    def snapshot_from_tracks tracks = []
      first = tracks.first

      klass = first.trackable_parent.relations[first.association_chain.last["name"]].class_name.constantize.snapshot_class_name.constantize
      attribs = tracks.first.modified

      tracks.each do |t|
        unless t.action == 'destroy'
          attribs.easy_merge!(t.modified)
        else
          attribs = nil
        end
      end

      snapshot = attribs ? klass.new : nil

      if snapshot
        attribs.each do |k,v|
          snapshot.create_attr(k)
          snapshot.send("#{k}=", v)
        end
      end

      return snapshot
    end
  end
end
