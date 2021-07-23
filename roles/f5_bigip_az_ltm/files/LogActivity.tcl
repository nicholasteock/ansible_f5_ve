when HTTP_REQUEST {
  log local0. "[IP::client_addr] access URI [HTTP::host][HTTP::uri] called by VIP: [virtual name]"
}
