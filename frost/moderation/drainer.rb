# frozen_string_literal: true

Rufus::Scheduler.singleton.every "1h" do
  # Audit all of the file related buckets.
  Moderation::FileSpam.audit(Time.now)

  # Audit all of the link related buckets.
  Moderation::LinkSpam.audit(Time.now)
end
