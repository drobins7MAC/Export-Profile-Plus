class ItemSetPaths < CustomFieldBase
	def name
		return "Item Set Paths"
	end

	#You may override this in derived class to provide a tool tip
	#for the given custom field
	def tool_tip
		return "Delimited list of paths for items which are a duplicate of a given item in select item sets, includes path of given item as well"
	end

	def decorate(profile)
		profile = profile.addMetadata("Item Set Paths") do |item|
			begin
				paths = []
				CustomFieldBase.item_sets.each do |item_set|
					dupes = item_set.findDuplicates(item)
					if CustomFieldBase.handle_excluded_items == true
						dupes = dupes.reject{|i|i.isExcluded}
					end
					dupes.each do |dupe_item|
						path_string = dupe_item.getPath.map{|i|i.getLocalisedName}.join("/")
						paths << path_string
					end
				end
				paths = paths.sort
				final_paths = []
				final_paths << item.getPath.map{|i|i.getLocalisedName}.join("/")
				final_paths += paths
				next final_paths.join(CustomFieldBase.delimiter)
			rescue Exception => exc
				next "Error: #{exc.message}"
			end
		end
		return profile
	end

	def needs_item_set
		return true
	end
end