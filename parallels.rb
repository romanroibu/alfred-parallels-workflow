require File.expand_path('alfredXML')

parallels_path = File.expand_path('~/Documents/Parallels/*')
vm_folders = Dir[parallels_path]

query = ARGV.join(' ').downcase

osinfo = {
  "7"  => ['MACOS',   'MacOS',   'os-mac_64x64.png'     ],
  "8"  => ['WINDOWS', 'Windows', 'os-windows_64x64.png' ],
  "9"  => ['LINUX',   'Linux',   'os-linux_64x64.png'   ],
  "10" => ['FREEBSD', 'FreeBSD', 'os-freebsd_64x64.png' ],
  "11" => ['OS2',     'OS/2',    'os-os2_64x64.png'     ],
  "12" => ['MSDOS',   'MS DOS',  'os-dos_64x64.png'     ],
  "14" => ['SOLARIS', 'Solaris', 'os-solaris_64x64.png' ]
}

output = vm_folders.map do |vm_folder|
  vmname = vm_folder.split('/').last[0..-5]

  config = File.read(vm_folder + '/config.pvs')
  ostype_xml = config.match(/<OsType>\d+<\/OsType>/)[0]
  num = ostype_xml.match(/\d+/)[0]

  ostype, osname, icon_name = osinfo[num]

  # Display only VMs with name or OS type matching query
  next unless vmname.downcase.include?(query) || ostype.downcase.include?(query)

  # Use user provided icon
  icon = File.expand_path("user_icons/#{vmname}.png")

  unless File.exists? icon
    # If user icon does not exist, use default
    icon = "/Library/QuickLook/ParallelsQL.qlgenerator/Contents/Resources/#{icon_name}"
  end

  {
    :uid => vmname,
    :arg => vm_folder,
    :icon => icon,
    :valid => 'yes',
    :title => vmname,
    :subtitle => "OS Type: #{osname}. Run #{vmname} virtual machine.",
    :autocomplete => vmname,
  }
end

puts alfredXML(output)
