# frozen_string_literal: true

Rufus::Scheduler.singleton.every "1h" do
  # Audit all of the file related buckets.
  Moderation::FileSpam.audit_buckets

  # Audit all of the link related buckets.
  Moderation::LinkSpam.audit_buckets
end
