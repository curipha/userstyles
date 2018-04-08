userstyles [![CircleCI](https://circleci.com/gh/curipha/userstyles.svg?style=svg)](https://circleci.com/gh/curipha/userstyles)
==========
Various userstyles to enhance browsing experience.

These userstyles work fine with modern web browsers/extensions.

- [Stylus](https://chrome.google.com/webstore/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne) with Google Chrome (use import functionality for Mozilla format)
- [Stylish](https://addons.mozilla.org/ja/firefox/addon/stylish/) with Firefox


Notes
-------------------------
### Bye-bye_MS_*.user.css
These styles work fine on Google Chrome (and probably Blink based-browser) only.
As far as I know, it is incompatible with Firefox and et al.
There is a difference in interpretation of `@font-face` directive between Firefox and Google Chrome.

If you are a Firefox user, `obsolete/Bye-bye_MS_*.user.css` may help you.
These obsoleted files are for Firefox.

### _export.rb
Run this script to convert Stylus (or maybe also works with Stylish) exported JSON file to standard `user.css` files.

```bash
$ ./_export.rb ./path/to/stylus-yyyy-mm-dd.json
```


Links
--------------------
### Fonts
- [Migmix](https://mix-mplus-ipa.osdn.jp/migmix/) (Japanese font)
- [Source Han Code JP](https://github.com/adobe-fonts/source-han-code-jp) (Japanese font)

