{ host, ... }:

{
  i18n.defaultLocale = host.locale;

  console.keyMap = "us";
}
