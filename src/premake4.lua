os_properties = 
{
	windows = { dir = 'win32', pythondir = 'windows' },
	macosx = { dir = 'osx', pythondir = 'osx' },
	linux = { dir = 'linux', pythondir = 'linux' },
}

props = {}

if _OPTIONS.os == nil then
   error('Please specify your target os!')
elseif os_properties[_OPTIONS.os] == nil then
	error('Unsupported os!')
else
	props = os_properties[_OPTIONS.os]
	props.outdir = "..\\..\\ds_mod_tools_out\\"
	props.skuoutdir = props.outdir..props.dir.."\\mod_tools\\"
	props.tooldir = '..\\tools\\bin\\'..props.dir.."\\"
end

apps = 
{
	'scml', 
	'png', 
	'autocompiler', 
	--'textureconverter'
}

libs = 
{
	--texturelib = { include_lib = true },
	modtoollib = { include_lib = false },
}

solution('mod_tools')
	configurations { "debug", "release" }
	location ( props.outdir.."proj" )
	flags { "Symbols", "NoRTTI", "NoEditAndContinue", "NoExceptions", "NoPCH" }
	includedirs { "lib", "../lib/" }
  	targetdir ( props.skuoutdir )

    configuration { "debug" }
        defines { "DEBUG", "_CRT_SECURE_NO_WARNINGS" }
   	configuration { "release" }
        defines { "RELEASE", "_CRT_SECURE_NO_WARNINGS" }
        flags { "Optimize" }	

	for k, app in pairs(apps) do	
	   	project(app)
			kind "ConsoleApp"
			language "C++"   	   
	      	files { "app/"..app.."/**.h", "app/"..app.."/**.cpp" }	 
	      	for lib, settings in pairs(libs) do
	      		links{ lib }
	      	end
	end

	for lib, settings in pairs(libs) do	
	   	project(lib)
			kind "StaticLib"
			language "C++"   	   
	      	files { "lib/"..lib.."/**.h", "lib/"..lib.."/**.cpp" }
	      	if settings.include_lib then
	      		includedirs { "lib/"..lib }
	      	end
	end

local function extract(file, folder)
	cmd = props.tooldir..'7z.exe -y x '..file..' -o'..folder
	os.execute(cmd)	
end

extract('..\\pkg\\cmn\\mod_tools.zip', props.outdir..props.dir)
extract('..\\pkg\\tst\\wand.zip', props.outdir..'dont_starve\\mods')
extract('..\\pkg\\'..props.dir..'\\mod_tools.zip', props.outdir..props.dir)
extract('..\\pkg\\'..props.dir..'\\Python27.zip', props.skuoutdir..'\\buildtools\\'..props.pythondir..'\\')