; Conceal inline links
(inline_link
  [
    "["
    "]"
    "("
    (link_destination)
    ")"
  ] @markup.link
  (#set! conceal ""))

; Conceal shortcut links
(shortcut_link
  [
    "["
    "]"
  ] @markup.link
  (#set! conceal ""))

; Conceal wikilinks
(wiki_link
  [
    "["
    "|"
    "]"
  ] @markup.link
  (#set! conceal ""))

; Conceal destination if there's a label
(wiki_link ((link_destination) "|") @markup.link (#set! conceal ""))

; Mark destinations without an explicit label
(wiki_link (link_destination) @markup.link.label)


[
  (link_label)
  (link_text)
  (link_title)
  (image_description)
] @markup.link.label
