-- reading /etc/config/users
m = Map("users", translate("Manage Users"), "Here you can see active system's users and manage their permissions")

-- get sections 'user'
s = m:section(TypedSection, "user")
s.addremove = false

-- show all users but root
function s:filter(value)
   return value ~= "root" and value
end

-- create tabs for each user
s:tab("credentials",  "Credentials")

-- create tab's fields (reads values from file)
s:taboption("credentials", Value, "username", "Username")
s:taboption("credentials", Value, "password", "Password", "clear password")

s:tab("pages",  "Pages")

-- for this 2 tabs I render a template
page = s:taboption("pages", Value, "node", "Pages", "The selected pages will be not available by the user")
page.template = "cbi/myapp/page_list"
page.widget = "checkbox"
page.cast = "string"

s:tab("subpages",  "Subpages")
subpage = s:taboption("subpages", Value, "subnode", "Subpages", "The selected subpages will not available by the user")
subpage.template = "cbi/myapp/subpage_list"
subpage.widget = "checkbox"
subpage.cast = "string"

return m
