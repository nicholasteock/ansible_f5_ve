#cli-pool-redirect

when HTTP_REQUEST {
  if { [string tolower [HTTP::header "User-Agent"]] contains "java" } {
    set disable_OneConnect_cli 1
  }
  else {
    set disable_OneConnect_cli 0
  }

  set http_uri [string tolower [HTTP::uri]]
  set sw [class match -value $http_uri starts_with dg_pool_redirects_sw]
  set eq [class match -value $http_uri equals dg_pool_redirects_eq]

  if {$eq ne ""} {
    scan $eq {%[^,],%s} pool1 pool2
  }
  elseif {$sw ne ""} {
    scan $sw {%[^,],%s} pool1 pool2
  }
  else {
    set pool1 cli-web-ssl
    set pool2 cli-web-ssl
  }

  if { ($pool2 eq "none") } {
    set pool2 $pool1
  }

  if { [active_members $pool1] > 0 } {
    pool $pool1
  }
  else {
    pool $pool2
  }
}

when HTTP_REQUEST_SEND {
  clientside {
    HTTP::header insert "BIGIP-Addr" [IP::local_addr]
  }
}

