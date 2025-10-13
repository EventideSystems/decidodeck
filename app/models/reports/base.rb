# frozen_string_literal: true

module Reports
  # Base class for reports
  class Base
    private

    DEFAULT_ALIGNMENT = { horizontal: :general, vertical: :bottom, wrap_text: true }.freeze

    def default_styles(package)
      header_styles(package).merge(
        {
          blue_normal: package.workbook.styles.add_style(fg_color: '386190', sz: 12, b: false),
          wrap_text: package.workbook.styles.add_style(
            alignment: DEFAULT_ALIGNMENT
          ),
          date: date_style(package)
        }
      )
    end

    def date_style(package)
      package.workbook.styles.add_style(format_code: 'd/m/yy')
    end

    def header_styles(package)
      {
        h1: package.workbook.styles.add_style(fg_color: '386190', sz: 16, b: true),
        h2: package.workbook.styles.add_style(bg_color: 'dce6f1', fg_color: '386190', sz: 12, b: true),
        h3: package.workbook.styles.add_style(bg_color: 'dce6f1', fg_color: '386190', sz: 12, b: false)
      }
    end

    def with_i18n_scope(locale: 'en', scope: nil) # rubocop:disable Metrics/MethodLength
      current_locale = I18n.locale
      current_scope = I18n::Backend::ActiveRecord.config.scope

      I18n.locale = locale

      if current_scope != scope
        I18n::Backend::ActiveRecord.config.scope = scope
        I18n.backend.reload!
      end

      yield if block_given?
    ensure
      I18n.locale = current_locale
      if current_scope != scope
        I18n::Backend::ActiveRecord.config.scope = current_scope
        I18n.backend.reload!
      end
    end
  end
end
