require 'spree_core'
#require 'multi_currencies_hooks'

module MultiCurrencies
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      Deface::Override.new(:virtual_path => "admin/configurations/index",
                    :name => "currency_admin_configurations_menu",
                    :insert_after => "[data-hook='admin_configurations_menu']",
                    :text =>  %(
                        <% if current_user.has_role?(:admin) %>
                         <tr>
                           <td><%= link_to t("currency_settings"), admin_currencies_path %></td>
                           <td><%= t("currency_description") %></td>
                         </tr>
                         <tr>
                           <td><%= link_to t("currency_converters_settings"), admin_currency_converters_path %></td>
                           <td><%= t("currency_converters_description") %></td>
                         </tr>
                        <% end %>
                       ),
                    :disabled => false)

    #   insert_after :admin_configurations_menu do
    # %(
    #   <% if current_user.has_role?(:admin) %>
    #    <tr>
    #      <td><%= link_to t("currency_settings"), admin_currencies_path %></td>
    #      <td><%= t("currency_description") %></td>
    #    </tr>
    #    <tr>
    #      <td><%= link_to t("currency_converters_settings"), admin_currency_converters_path %></td>
    #      <td><%= t("currency_converters_description") %></td>
    #    </tr>

    #   <% end %>
    #  )


    end

    config.to_prepare &method(:activate).to_proc
  end
end
