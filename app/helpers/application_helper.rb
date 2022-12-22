module ApplicationHelper
  def page_entries_info_hash(collection, entry_name: nil)
    result = {}
    entry_name = if entry_name
                   entry_name.pluralize(collection.size, I18n.locale)
                 else
                   collection.entry_name(total: collection.size).downcase
                 end

    if collection.total_pages < 2
      result = { entry_name: entry_name, total: collection.total_count }
    else
      from = collection.offset_value + 1
      to   = collection.offset_value + (collection.respond_to?(:records) ? collection.records : collection.to_a).size

      result = { entry_name: entry_name, first: from, last: to, total: collection.total_count }
    end
    result
  end
end
