local function ltex_get_language(_, filetype)
  local language_id_mapping = {
    bib = 'bibtex',
    plaintex = 'tex',
    rnoweb = 'rsweave',
    rst = 'restructuredtext',
    tex = 'latex',
    pandoc = 'markdown',
    text = 'plaintext',
  }
  local language_id = language_id_mapping[filetype]
  if language_id then
    return language_id
  else
    return filetype
  end
end
