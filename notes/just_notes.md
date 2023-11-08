# Notes

## Plist
Convert plist raw base64 data to hex
```bash
plutil -extract <key> raw /path/to/plist_file.plist -o - | base64 -d | xxd -p -c 10000
```

Convert hex data to human-readable output
```bash
echo "<hex_data>" | xxd -r -p | plutil -convert xml1 -o - -
```
