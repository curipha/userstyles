userstyles [![CircleCI](https://circleci.com/gh/curipha/userstyles.svg?style=svg)](https://circleci.com/gh/curipha/userstyles)
==========
Various userstyles to enhance browsing experience.

These userstyles work fine on:

- Stylish with Firefox
- Stylus with Google Chrome (use import functionality for Mozilla format)
- ... and also other modern browsers/extensions

----

Userstyles beginning with "XUL" are dedicated for Firefox UI.

Just a few of styles still contain incompatibility with Google Chrome since the `-moz` prefix is used.
Run the following command to find these scripts.

```bash
grep -P -- '-moz(?!-document)\b' *.css
```


Descriptions
-------------------------
### Bye-bye_MS_*.user.css
This style is works fine on Firefox only. It is incompatible with Google Chrome.
There is a difference in interpretation of `@font-face` directive between Firefox and Google Chrome.

### _export.sh
Run this script to export all userstyles stored in Firefox's user profile directory.
It works for **Stylish with Firefox on Windows only**.


Links
--------------------
### Fonts
- [Migmix](https://mix-mplus-ipa.osdn.jp/migmix/) (Japanese font)
- [Source Han Code JP](https://github.com/adobe-fonts/source-han-code-jp) (Japanese font)

