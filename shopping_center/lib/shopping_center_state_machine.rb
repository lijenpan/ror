module ShoppingCenterStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine :initial => :researcher_collecting do
      state :researcher_collecting
      state :awaiting_promotion
      state :awaiting_verification
      state :manager_collecting
      state :stalled
      state :error
      state :incomplete
      state :destroy
      state :trashed
      state :searchable

      event :scsm_save do
        transition :researcher_collecting => :awaiting_promotion
        transition :manager_collecting => :awaiting_verification
      end

      event :scsm_verify do
        transition :awaiting_verification => :searchable
      end

      event :scsm_trash do
        transition :searchable => :trashed
      end

      event :scsm_restore do
        transition :trashed => :searchable
      end

      event :scsm_edit do
        transition :incomplete => :researcher_collecting
        transition :error => :researcher_collecting
        transition :awaiting_promotion => :researcher_collecting
        transition :awaiting_verification => :manager_collecting
      end

      event :scsm_error_found do
        transition :searchable => :error
        transition :awaiting_verification => :error
      end

      event :scsm_collect_more_data do
        transition :awaiting_verification => :incomplete
        transition :searchable => :incomplete
      end

      event :scsm_stall do
        transition :awaiting_verification => :stalled
      end

      event :scsm_destroy do
        transition :stalled => :killed
        transition :incomplete => :killed
        transition :error => :killed
      end

      event :scsm_unstall do
        transition :stalled => :awaiting_verification
      end

      event :scsm_promote do
        transition :awaiting_promotion => :awaiting_verification
      end
    end
  end
end
