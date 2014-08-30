
$ErrorActionPreference = "Stop"
$LCMConfigFolder = "$env:windir\System32\Configuration"

Remove-Item $LCMConfigFolder\*.mof | out-null

configuration PuppetConfiguration
{
<% if resource.parameters[:dscmeta_module_name] && resource[:dscmeta_import_resource] -%>
    Import-DscResource <%= "-Name #{resource[:dscmeta_resource_name]}" if resource.parameters[:dscmeta_resource_name] %> <%= "-ModuleName #{resource[:dscmeta_module_name]}" if resource.parameters[:dscmeta_module_name] %>
<% end -%>

    node "localhost"
    {
      <%= resource[:dscmeta_resource_friendly_name] %> "<%= resource.title %>"
        {
<% dsc_parameters.each do |p| -%>
           <%= p.name.to_s.gsub(/^dsc_/,'') %> = <%= format_dsc_value(p.value) %>
<% end -%>
        }
    }
}
$LCMConfigFolder = "$env:windir\System32\Configuration"
PuppetConfiguration -OutputPath $LCMConfigFolder | out-null
Move-Item $LCMConfigFolder\localhost.mof $LCMConfigFolder\current.mof | out-null
$test_return = Test-DscConfiguration
Remove-Item $LCMConfigFolder\*.mof | out-null
return $test_return