require 'redcarpet'
class ImpressRenderer < Redcarpet::Render::HTML
  @@attrs = []
  @@current = 0
  @@head = ""

  def self.init_with_attrs att
    @@attrs = att
    @@current = 0
  end

  def self.set_head head
    @@head = head
  end

  def get_attrs(index=nil)
    # this is how we later inject attributes into pages. what an awful hack.
    index = @@current += 1 unless index
    att = @@attrs[index]
    class_att = "step"

    # add user-specified class
    if att =~ /class\s*=\s*"([^"]*)"/
      att = $` + $'
      class_att = "step #{$~[1]}"
    end

    return %{class="#{class_att}" #{att}}
  end

  def hrule
    %{</div>
      <div #{get_attrs}>
    }
  end

  def block_code code, lang
    "<pre><code class='prettyprint'>#{code}</code></pre>"
  end

  def codespan code
    "<code class='inline prettyprint'>#{code}</code>"
  end

  def doc_header
    %{
<html>
  <head>
    <link href="css/reset.css" rel="stylesheet" />
    <!-- Code Prettifier: -->
<link href="css/prettify.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="js/prettify.js"></script>
    <link href="css/style.css" rel="stylesheet" />
#{@@head}
  </head>

  <body onload="prettyPrint()">
    <div id="impress">
    <div #{get_attrs 0}>
    }
  end

  def doc_footer
    %{
      </div>
    <script src="js/impress.js"></script>
    <script>impress();</script>
  </body>
</html>
    }
  end
end

