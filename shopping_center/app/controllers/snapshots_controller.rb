class SnapshotsController < ApplicationController
  before_filter :find_snapshotable
  respond_to :html, :json, :js

  def snapshot
    @snapshot = @snapshotable.snapshot(Time.at(params[:created_at].to_i))
    render "#{@snapshotable.class.to_s.underscore.pluralize}/snapshot", layout: "application"
  end

  private
  def find_snapshotable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @snapshotable = $1.to_class.find(value)
      end
    end

    raise Mongoid::Errors::DocumentNotFound.new(t(:snapshot_not_found, :value => value)) if @snapshotable.nil?
  end
end
