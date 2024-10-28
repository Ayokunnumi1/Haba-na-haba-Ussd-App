module ImpactHelper
    def icon_name(index)
      icons = ["Clock", "Calender", "Pie Chart", "Handshake"]
      icons[index]
    end
  
    def impact_value(index)
      values = ["240+", "1000 M TONS", "6000 KG", "72+"]
      values[index]
    end
  
    def impact_label(index)
      labels = ["Food Donations", "Current Year", "Current Year food collection", "Partnerships"]
      labels[index]
    end
  
    def impact_item(icon, size_classes, name, value, label)
      <<-HTML.html_safe
        <div class="flex flex-col items-center text-center p-4">
          <img src="/assets/#{icon}" alt="#{name}" class="#{size_classes} mb-2"> <!-- Adjust the margin-bottom -->
          <p class="font-bold text-lg sm:text-2xl lg:text-3.8xl mb-1">#{value}</p> <!-- Adjust the margin-bottom -->
          <p class="font-normal text-xs sm:text-base lg:text-lg">#{label}</p>
        </div>
      HTML
    end
  end
  