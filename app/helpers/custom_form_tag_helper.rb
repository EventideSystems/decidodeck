# frozen_string_literal: true

# Helper methods for form tags
module CustomFormTagHelper
  def base_color_select_tag(name, selected = 'red', options = {})
    default_opts = { class: base_color_select_class(selected),
                     data: CustomFormBuilder::BASE_COLOR_SELECT_DATA_ATTRIBUTES }

    content_tag(:div, data: { controller: 'base-color-select' }) do
      select_tag(name, options_for_select(CustomFormBuilder::OPTIONS_FOR_BASE_COLOR_SELECT, selected),
                 default_opts.merge(options))
    end
  end

  # mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm
  def custom_date_field_tag(name, value = nil, options = {})
    default_opts = { class: "#{CustomFormBuilder::TEXT_FIELD_CLASS} mt-2 dark:[color-scheme:dark]" }

    content_tag(:div) do
      date_field_tag(name, value, default_opts.merge(options))
    end
  end

  def custom_label_tag(name = nil, content_or_options = nil, options = {}, &block)
    default_opts = { class: "#{CustomFormBuilder::LABEL_CLASS} mt-2" }
    label_tag(name, content_or_options, default_opts.merge(options), &block)
  end

  def custom_text_area_tag(name, content = nil, options = {})
    default_opts = { class: "#{CustomFormBuilder::TEXT_AREA_CLASS} mt-2" }

    text_area_tag(name, content, default_opts.merge(options))
  end

  def custom_text_field_tag(name, value = nil, options = {})
    default_opts = { class: "#{CustomFormBuilder::TEXT_FIELD_CLASS} mt-2" }

    # content_tag(:div) do
    text_field_tag(name, value, default_opts.merge(options))
    # end
  end

  def custom_select_tag(name, option_tags = nil, options = {})
    default_opts = { class: "#{CustomFormBuilder::SELECT_FIELD_CLASS} mt-2" }

    content_tag(:div) do
      select_tag(name, option_tags, default_opts.merge(options))
    end
  end

  private

  def base_color_select_class(selected)
    "#{CustomFormBuilder::SELECT_FIELD_CLASS} bg-#{selected}-500"
  end
end
