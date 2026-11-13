{ ... }:
{
  dependenciesDeclared = false;
  descriptorVersion = "zenlang.semantic/2";
  grammarVersion = "1.0.0Na";
  id = "pkgs.org.kde.kid3";
  imports = [ ];
  irVersion = "1.0.0Na";
  kind = "zpkg";
  location = "/nix/store/3ni594f60hm22hcrazxd35dmk7pwi61m-zenpkgs-dsl-source/pkgs/apps/audio/kid3.zpkg:41:8";
  metadata = {
    description = {
      multiline = true;
      parts = [
        {
          type = "text";
          value = "\n    If you want to easily tag multiple MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC,\n    MP2, Opus, Speex, TrueAudio, WavPack, WMA, WAV and AIFF files (e.g. full\n    albums) without typing the same information again and again and have\n    control over both ID3v1 and ID3v2 tags, then Kid3 is the program you are\n    looking for.\n\n    With Kid3 you can:\n    - Edit ID3v1.1 tags;\n    - Edit all ID3v2.3 and ID3v2.4 frames;\n    - Convert between ID3v1.1, ID3v2.3 and ID3v2.4 tags\n    - Edit tags in MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC, MP2, Opus, Speex,\n      TrueAudio, WavPack, WMA, WAV, AIFF files and tracker modules (MOD, S3M,\n      IT, XM);\n    - Edit tags of multiple files, e.g. the artist, album, year and genre of\n      all files of an album typically have the same values and can be set\n      together;\n    - Generate tags from filenames;\n    - Generate tags from the contents of tag fields;\n    - Generate filenames from tags;\n    - Rename and create directories from tags;\n    - Generate playlist files;\n    - Automatically convert upper and lower case and replace strings;\n    - Import from gnudb.org, TrackType.org, MusicBrainz, Discogs, Amazon and\n      other sources of album data;\n    - Export tags as CSV, HTML, playlists, Kover XML and in other formats;\n    - Edit synchronized lyrics and event timing codes, import and export\n      LRC files.\n  ";
        }
      ];
      type = "string";
    };
    id = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "org.kde.kid3";
        }
      ];
      type = "string";
    };
    license = {
      name = "l";
      path = [
        {
          kind = "identifier";
          value = "lgpl2Plus";
        }
      ];
      type = "variable";
    };
    maintainers = {
      items = [
        {
          name = "m";
          path = [
            {
              kind = "identifier";
              value = "doromiert";
            }
          ];
          type = "variable";
        }
      ];
      type = "list";
    };
    name = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Kid3";
        }
      ];
      type = "string";
    };
    packageVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "3.9.7";
        }
      ];
      type = "string";
    };
    summary = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "Simple and powerful audio tag editor";
        }
      ];
      type = "string";
    };
    tags = {
      items = [
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "audio";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "metadata";
            }
          ];
          type = "string";
        }
        {
          multiline = false;
          parts = [
            {
              type = "text";
              value = "multimedia";
            }
          ];
          type = "string";
        }
      ];
      type = "list";
    };
    zenosVersion = {
      multiline = false;
      parts = [
        {
          type = "text";
          value = "1.0.0";
        }
      ];
      type = "string";
    };
  };
  name = "kid3";
  packageImport = {
    name = "pkgs";
    path = [
      {
        kind = "identifier";
        value = "legacy";
      }
      {
        kind = "identifier";
        value = "kid3";
      }
    ];
    type = "variable";
  };
  provider = {
    expression = {
      name = "pkgs";
      path = [
        {
          kind = "identifier";
          value = "legacy";
        }
        {
          kind = "identifier";
          value = "kid3";
        }
      ];
      type = "variable";
    };
    kind = "import";
  };
  statements = [
    {
      operator = "=";
      target = [
        {
          kind = "identifier";
          value = "_meta";
        }
      ];
      type = "assignment";
      value = {
        recursive = false;
        statements = [
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "id";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "org.kde.kid3";
                }
              ];
              type = "string";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "name";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "Kid3";
                }
              ];
              type = "string";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "summary";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "Simple and powerful audio tag editor";
                }
              ];
              type = "string";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "description";
              }
            ];
            type = "assignment";
            value = {
              multiline = true;
              parts = [
                {
                  type = "text";
                  value = "\n    If you want to easily tag multiple MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC,\n    MP2, Opus, Speex, TrueAudio, WavPack, WMA, WAV and AIFF files (e.g. full\n    albums) without typing the same information again and again and have\n    control over both ID3v1 and ID3v2 tags, then Kid3 is the program you are\n    looking for.\n\n    With Kid3 you can:\n    - Edit ID3v1.1 tags;\n    - Edit all ID3v2.3 and ID3v2.4 frames;\n    - Convert between ID3v1.1, ID3v2.3 and ID3v2.4 tags\n    - Edit tags in MP3, Ogg/Vorbis, FLAC, MPC, MP4/AAC, MP2, Opus, Speex,\n      TrueAudio, WavPack, WMA, WAV, AIFF files and tracker modules (MOD, S3M,\n      IT, XM);\n    - Edit tags of multiple files, e.g. the artist, album, year and genre of\n      all files of an album typically have the same values and can be set\n      together;\n    - Generate tags from filenames;\n    - Generate tags from the contents of tag fields;\n    - Generate filenames from tags;\n    - Rename and create directories from tags;\n    - Generate playlist files;\n    - Automatically convert upper and lower case and replace strings;\n    - Import from gnudb.org, TrackType.org, MusicBrainz, Discogs, Amazon and\n      other sources of album data;\n    - Export tags as CSV, HTML, playlists, Kover XML and in other formats;\n    - Edit synchronized lyrics and event timing codes, import and export\n      LRC files.\n  ";
                }
              ];
              type = "string";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "zenosVersion";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "1.0.0";
                }
              ];
              type = "string";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "packageVersion";
              }
            ];
            type = "assignment";
            value = {
              multiline = false;
              parts = [
                {
                  type = "text";
                  value = "3.9.7";
                }
              ];
              type = "string";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "tags";
              }
            ];
            type = "assignment";
            value = {
              items = [
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "audio";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "metadata";
                    }
                  ];
                  type = "string";
                }
                {
                  multiline = false;
                  parts = [
                    {
                      type = "text";
                      value = "multimedia";
                    }
                  ];
                  type = "string";
                }
              ];
              type = "list";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "maintainers";
              }
            ];
            type = "assignment";
            value = {
              items = [
                {
                  name = "m";
                  path = [
                    {
                      kind = "identifier";
                      value = "doromiert";
                    }
                  ];
                  type = "variable";
                }
              ];
              type = "list";
            };
          }
          {
            operator = "=";
            target = [
              {
                kind = "identifier";
                value = "license";
              }
            ];
            type = "assignment";
            value = {
              name = "l";
              path = [
                {
                  kind = "identifier";
                  value = "lgpl2Plus";
                }
              ];
              type = "variable";
            };
          }
        ];
        type = "attr-set";
      };
    }
    {
      package = {
        name = "pkgs";
        path = [
          {
            kind = "identifier";
            value = "legacy";
          }
          {
            kind = "identifier";
            value = "kid3";
          }
        ];
        type = "variable";
      };
      type = "package-import";
    }
  ];
  target = [
    "org"
    "kde"
    "kid3"
  ];
}
