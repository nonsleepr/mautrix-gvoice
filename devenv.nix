{ pkgs, lib, config, inputs, ... }:

{
  languages.go.enable = true;
  languages.javascript = {
    enable = true;
    npm = {
      enable = true;
    };
  };

  #env.MAUTRIX_GVOICE_PUPPETEER_DEBUG = "true";
  env.NODE_PATH = "/home/nonsleepr/code/mautrix-gvoice/node_modules";
  env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
  env.PUPPETEER_EXECUTABLE_PATH = "${pkgs.chromium}/bin/chromium";
  #env.HTTP_PROXY = "http://127.0.0.1:8080";
  #env.HTTPS_PROXY = "http://127.0.0.1:8080";
  #env.NO_PROXY = "localhost,matrix.beeper.com";
  #env.SSL_CERT_FILE = "/home/nonsleepr/Downloads/burpsuite.cacert.der";

  packages = with pkgs; [
    olm
  ];
}
