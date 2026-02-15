{pkgs, ...}: {
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh";
  };

  environment.systemPackages = [pkgs.keyd];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*" "0002:000a # Thinkpad mouse buttons"];
        settings = {
          global = {
            oneshot_timeout = 200;
            chord_timeout = 35;
          };
          main = {
            "w+e" = "macro(C-backspace)";
            "w+e+f" = "macro(S-enter)";
            "i+o" = "escape";
            "i+o+j" = "macro(S-enter)";
            "a+d+c" = "tab";
            # "lijk"
            "c+i+l" = "macro(ulyn)";
            # "ijk"
            "c+l+j" = "macro(lyn)";
            # "ij"
            "c+l+k" = "macro(ly)";
            # "function "
            "r+u" = "macro(eijxfl;j space)";
            # "fn () => "
            "d+r+u" = "macro(ej space () space => space left left left left left)";
            "k+r+u" = "macro(ej space () space => space left left left left left)";
            # "return "
            "e+i" = "macro(skfisj space)";
            # "private "
            "w+o" = "macro(rslvafk space)";
            # "protected "
            "d+w+o" = "macro(rs;fkxfkc space)";
            "k+w+o" = "macro(rs;fkxfkc space)";
            # "public "
            "f+w+o" = "macro(ritulx space)";
            "j+w+o" = "macro(ritulx space)";
            # "if () {}"
            "q+p" = "macro(le space () space {} left left left left)";
            # "match () {}"
            "f+q+p" = "macro(hafxm space () space {} left left left left)";
            "j+q+p" = "macro(hafxm space () space {} left left left left)";
            # "foreach ("
            "d+q+p" = "macro(e;skaxm space () space {} left left left left)";
            "k+q+p" = "macro(e;skaxm space () space {} left left left left)";
            # "array"
            "c+m" = "macro(assao)";
            # "string"
            "d+c+m" = "macro(dfsljg)";
            "k+c+m" = "macro(dfsljg)";
            # "false"
            "x+," = "macro(eaudk)";
            # "true"
            "f+x+," = "macro(fsik)";
            "j+x+," = "macro(fsik)";
            # "bool"
            "l+x+," = "macro(t;;u)";
            # "--help "
            "m+k+r" = "macro(--mkur space)";
            "space+t+y" = "macro(``` S-enter ``` up)";
            w = "overloadi(w, overloadt(nav_edit, w, 105), 35)";
            a = "overloadi(a, overloadt(meta, a, 160), 45)";
            s = "overloadi(s, overloadt(alt, s, 180), 45)";
            d = "overloadi(d, overloadt(shift, d, 105), 45)";
            f = "overloadi(f, overloadt(control, f, 110), 45)";
            j = "overloadi(j, overloadt(control, j, 110), 45)";
            k = "overloadi(k, overloadt(shift, k, 105), 45)";
            l = "overloadi(l, overloadt(alt, l, 180), 45)";
            ";" = "overloadi(;, overloadt(meta, ;, 160), 35)";
            space = "overloadi(space, overloadt(symbol_number, space, 110), 35)";
            "leftshift+rightshift" = "toggle(smart_caps)";
            "d+k+space" = "toggle(smart_num)";
          };

          shift = {
            # "foreach ("
            "q+p" = "macro(e;skaxm space () space {} left left left left)";
            # "protected "
            "w+o" = "macro(rs;fkxfkc space)";
            # "fn () => "
            "r+u" = "macro(ej space () space => space left left left left left)";
            # "string"
            "c+m" = "macro(dfsljg)";
          };

          control = {
            # "match () {}"
            "q+p" = "macro(hafxm space () space {} left left left left)";
            # "public "
            "w+o" = "macro(ritulx space)";
            # "true"
            "x+," = "macro(fsik)";
          };

          alt = {
            # "bool"
            "x+," = "macro(t;;u)";
            space = "toggle(pascal_case)";
          };

          symbol_number = {
            "t+y" = "macro(``` S-enter ``` up)";
            "r+u" = "macro(->)";
            "e+i" = "macro(=>)";
            # $this->
            "w+o" = "macro($fmld->)";
            # {{ <cursor> }}
            "q+p" = "macro({{ space space  }} left left left)";
            g = "|";
            f = "(";
            d = "{";
            s = "[";
            a = "=";
            z = "\\";
            x = "%";
            c = "-";
            v = "_";
            h = "*";
            j = ")";
            k = "}";
            l = "]";
            ";" = "$";
            n = "&";
            m = ">";
            "," = "+";
            q = "1";
            w = "2";
            e = "3";
            r = "4";
            t = "5";
            y = "6";
            u = "7";
            i = "8";
            o = "9";
            p = "0";
          };

          smart_num = {
            c = "-";
            e = "/";
            a = "1";
            s = "2";
            d = "3";
            f = "lettermod(control, 4, 35, 130)";
            g = "5";
            h = "6";
            j = "lettermod(control, 7, 35, 130)";
            k = "8";
            l = "9";
            ";" = "0";
            m = "+";
            i = "*";
            # w = "lettermod(nav_edit, noop, 35, 105)";
            space = "togglem(smart_num, macro(space))";
            escape = "togglem(smart_num, macro(escape))";
            tab = "togglem(smart_num, macro(tab))";
            enter = "togglem(smart_num, macro(enter))";
          };

          nav_edit = {
            q = "scroll(15)";
            e = "pageup";
            r = "pagedown";
            a = "layer(meta)";
            s = "layer(alt)";
            d = "layer(shift)";
            f = "layer(control)";
            u = "home";
            i = "escape";
            o = "end";
            "'" = "enter";
            h = "enter";
            j = "left";
            k = "down";
            l = "up";
            ";" = "right";
            m = "backspace";
            "," = "delete";
            space = "enter";
          };

          smart_caps = {
            a = "A";
            b = "B";
            c = "C";
            d = "D";
            e = "E";
            f = "lettermod(control, F, 35, 130)";
            g = "G";
            h = "H";
            i = "I";
            j = "lettermod(control, J, 35, 130)";
            k = "K";
            l = "L";
            m = "M";
            n = "N";
            o = "O";
            p = "P";
            q = "Q";
            r = "R";
            s = "S";
            t = "T";
            u = "U";
            v = "V";
            w = "lettermod(nav_edit, W, 35, 105)";
            x = "X";
            y = "Y";
            z = "Z";
            space = "lettermod(symbol_number, togglem(smart_caps, macro(space)), 35, 120)";
            escape = "togglem(smart_caps, macro(escape))";
            tab = "togglem(smart_caps, macro(tab))";
            enter = "togglem(smart_caps, macro(enter))";
            leftshift = "togglem(smart_caps, macro(leftshift))";
            rightshift = "togglem(smart_caps, macro(rightshift))";
          };

          pascal_case = {
            space = "lettermod(symbol_number, oneshot(shift), 35, 120)";
            escape = "togglem(pascal_case, macro(escape))";
            tab = "togglem(pascal_case, macro(tab))";
            enter = "togglem(pascal_case, macro(enter))";
            leftshift = "togglem(pascal_case, macro(leftshift))";
            rightshift = "togglem(pascal_case, macro(rightshift))";
          };
        };
      };
    };
  };
}
