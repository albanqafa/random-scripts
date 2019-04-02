#PowerShell script to patch Scheduall after Windows updates that address Spectre/Meltdown break it
#written by Alban Qafa
$fixedfile = @'
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <configSections>
    <section name="enterpriseLibrary.ConfigurationSource" type="Microsoft.Practices.EnterpriseLibrary.Common.Configuration.ConfigurationSourceSection, Microsoft.Practices.EnterpriseLibrary.Common, Version=6.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"/>
    <section name="entityFramework" type="System.Data.Entity.Internal.ConfigFile.EntityFrameworkSection, EntityFramework, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" requirePermission="false"/>
  </configSections>
  <enterpriseLibrary.ConfigurationSource selectedSource="File Configuration Source">
    <sources>
      <add name="File Configuration Source" type="Microsoft.Practices.EnterpriseLibrary.Common.Configuration.FileConfigurationSource, Microsoft.Practices.EnterpriseLibrary.Common, Version=6.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" filePath="EntLib.config" />
      <add name="System Configuration Source" type="Microsoft.Practices.EnterpriseLibrary.Common.Configuration.SystemConfigurationSource, Microsoft.Practices.EnterpriseLibrary.Common, Version=6.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" />
    </sources>
  </enterpriseLibrary.ConfigurationSource>
  <entityFramework configSource="EntityFramework.config"  />

  <runtime>
    <generatePublisherEvidence enabled="false"/>
    <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Practices.Unity" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-3.5.0.0" newVersion="3.5.0.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Practices.Unity.Configuration" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-3.5.0.0" newVersion="3.5.0.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Practices.ServiceLocation" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-1.2.0.0" newVersion="1.2.0.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Data.Edm" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-5.6.3.0" newVersion="5.6.3.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Data.OData" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-5.6.3.0" newVersion="5.6.3.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="System.Spatial" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-5.6.3.0" newVersion="5.6.3.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Data.Services.Client" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-5.6.3.0" newVersion="5.6.3.0" />
      </dependentAssembly>
      <dependentAssembly>
        <assemblyIdentity name="Microsoft.Data.Services" publicKeyToken="31bf3856ad364e35" culture="neutral" />
        <bindingRedirect oldVersion="0.0.0.0-5.6.3.0" newVersion="5.6.3.0" />
      </dependentAssembly>
    </assemblyBinding>
  </runtime>
  <system.data>
    <DbProviderFactories>
      <remove invariant="Devart.Data.Oracle"/>
      <add name="dotConnect for Oracle" invariant="Devart.Data.Oracle" description="Devart dotConnect for Oracle" type="Devart.Data.Oracle.OracleProviderFactory, Devart.Data.Oracle, Version=8.5.563.0, Culture=neutral, PublicKeyToken=09af7300eec23701"/>
    </DbProviderFactories>
  </system.data>
  <startup>
    <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.0"/>
  </startup>

  <!--
  <system.diagnostics>
    <sources>
      <source name="System.ServiceModel.MessageLogging">
        <listeners>
          <add name="vizuall-svc" />
        </listeners>
      </source>
      <source name="System.ServiceModel" switchValue="Verbose, ActivityTracing" propagateActivity="true">
        <listeners>
          <add name="vizuall-svc" />
        </listeners>
      </source>
    </sources>
    <trace autoflush="true" indentsize="4">
      <listeners>
        <remove name="Default" />
        <add name="SvcListener"  type="System.Diagnostics.TextWriterTraceListener"    initializeData="c:\temp\coretrace.log" />
        <add name="console-svc" />
      </listeners>
    </trace>
    <switches>
      <add name="ProfileSwitch" value="0" />
      <add name="SysPrefs" value="0" />
      <add name="Authentication" value="0" />
      <add name="Identity" value="0" />
      <add name="Availability" value="0" />
      <add name="Storage" value="0" />
      <add name="ChorusSwitch" value="0" />
      <add name="ServiceCallManagerSwitch" value="4" />
    </switches>
    <sharedListeners>
      <add name="vizuall-svc" type="VizuALL.Common.ServiceModel.ConfigurableTraceListener,VizuALL.Common" initializeData="c:\temp\core.svclog" FileSizeCutOffKB="10000" FileCount="2" />
      <add name="console-svc" type="System.Diagnostics.ConsoleTraceListener" />
    </sharedListeners>
  </system.diagnostics>
  -->
  <appSettings>

    <add key="wcf:useLegacyCertificateApplicationPolicy" value="true" />

    <add key="wcf:useLegacyCertificateUsagePolicy" value="true" />

  </appSettings>

  
</configuration>
'@
$schedconfig = "C:\ScheduALL5\Schedwin\Schedwin.exe.config"
$currentfile = get-filehash $schedconfig | format-list -property hash | out-string
$currenthash = $currentfile -replace '\r\n',''
$goodhash = "Hash : AE2203F8A1C85F3FA0B7E18B6206E51051F0191E33927DFFA981B1022683A7D2"
if (test-path $schedconfig) {
	if ($currenthash -eq $goodhash) {
		exit 0}
	else {
		$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
		[System.IO.File]::WriteAllLines($schedconfig, $fixedfile, $Utf8NoBomEncoding)
		if ($currenthash -eq $goodhash) {
			exit 0}
		else {
			exit 1}}
else {
	exit 1}}
 
