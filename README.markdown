# remember_layout

Remember keyboard layout when switching between applications. In case default system behavior doesn't work for you, doesn't work as expected or doesn't work at all.

## launchd.plist

Create `~/Library/LaunchAgents/com.example.remember_layout.plist` with content replacing `com.example` with domain you want and `/path/to` with path to `remember_layout`:

```xml
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version='1.0'>
<dict>
	<key>Label</key><string>com.example.remember_layout</string>
	<key>ProgramArguments</key>
	<array>
		<string>/path/to/remember_layout</string>
	</array>
	<key>KeepAlive</key><true/>
</dict>
</plist>
```
