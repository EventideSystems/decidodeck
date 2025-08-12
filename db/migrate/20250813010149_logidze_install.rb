class LogidzeInstall < ActiveRecord::Migration[8.0]
  def change
    create_function :logidze_capture_exception, version: 1

    create_function :logidze_compact_history, version: 1

    create_function :logidze_filter_keys, version: 1

    create_function :logidze_logger, version: 5

    create_function :logidze_logger_after, version: 5

    create_function :logidze_snapshot, version: 3

    create_function :logidze_version, version: 2

  end
end
