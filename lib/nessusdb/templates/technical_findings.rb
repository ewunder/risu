text findings.classification, :align => :center
text "\n"

font_size(24) { text findings.title, :align => :center }
font_size(18) { 
	text "Critical and High Findings", :align => :center
	text "\n"
	text "This report was prepared by\n#{findings.author}", :align => :center
}
text "\n\n\n"

findings.findings_array_unique.each do |h|
	if h[:values].length > 1
		font_size(24) { 
			fill_color h[:color]
			text h[:title] 
			fill_color "000000"
			}
		
		text "\n"
		
		h[:values].each do |f|
      hosts = Item.find(:all, :conditions => {:plugin_id => f.plugin_id })
      plugin = Plugin.find_by_id(f.plugin_id)
      references = Reference.find(:all, :group => :value, :order => :reference_name, :order => :reference_name, :conditions => {:plugin_id => plugin.id})
						
			font_size(18) { text "#{plugin.plugin_name}\n" }

    	if hosts.length > 1
				text "Hosts", :style => :bold
			else
				text "Host", :style => :bold
			end

			hostlist = Array.new
			hosts.each do |host|
				h = Host.find_by_id(host.host_id)
				hostlist << h.name
			end

			text hostlist.join(', ')

			if f.plugin_output != nil
				text "\nPlugin output", :style => :bold
				text f.plugin_output
			end
		
			if plugin.description != nil
				text "\nDescription", :style => :bold
				text plugin.description
			end
		
			if plugin.synopsis != nil
				text "\nSynopsis", :style => :bold
				text plugin.synopsis
			end			
		
			if plugin.cvss_base_score != nil
				text "\nCVSS Base Score", :style => :bold
				text plugin.cvss_base_score
			end
		
			if plugin.solution != nil
				text "\nSolution", :style => :bold
				text plugin.solution
			end
					
	    if references.size != 0
	      text "\nReferences", :style => :bold
	      references.each { |ref|
	        ref_text = sprintf "%s: %s\n", ref.reference_name, ref.value
	        text ref_text
	      }
				text "nessuspluginid: #{f.plugin_id}"
	    end
				text "\n"
		end
	end
	start_new_page
end