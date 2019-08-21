#!/usr/bin/python3
import subprocess
import sys
import os
import argparse

protocol_http = 'http'
protocol_https = 'https'

reverse_proxy_nginx = 'nginx'
reverse_proxy_varnish = 'varnish'
reverse_proxy_httpd = 'httpd'
reverse_proxy_none = 'none'

method_get = 'get'
method_post = 'post'

cache_off = 'off'
cache_on = 'on'

rest_type_auto = 'auto'
rest_type_manual = 'manual'

def setup(protocol, reverse_proxy, method, cache, rest_type, port):
#    print("protocol=%s, reverse_proxy=%s, method=%s, cache=%s, rest_type=%s, Port=%s" % (protocol, reverse_proxy, method, cache, rest_type, port))

    if ((reverse_proxy == reverse_proxy_none) and (cache == cache_on)):
        print("Invalid testing combo")
        return

    if port is None:
        if reverse_proxy == reverse_proxy_none:
            port = 1000
        elif reverse_proxy == reverse_proxy_httpd:
            port = 2000
        elif reverse_proxy == reverse_proxy_nginx:
            port = 3000
        elif reverse_proxy == reverse_proxy_varnish:
            port = 4000

        if protocol == protocol_http:
            port += 100
        elif protocol == protocol_https:
            port += 200

        if cache == cache_off:
            port += 10
        elif method == method_get: 
            port += 20
        elif method == method_post:             
            port += 30

    with open('/etc/siege/urls.txt','r+') as f:
        f.seek(0)
        for emp in range(100, 200):
            if rest_type == rest_type_auto:
                base_url = '%s://ords:%d/ords/hr/auto_rest_employee' % (protocol,port)
            else:
                base_url = '%s://ords:%d/ords/hr/manual_rest/employee' % (protocol,port)

            if method == method_post:
                full_url = '%s POST employee_id=%d' % (base_url,emp)
            else:
                full_url = '%s/%d' % (base_url,emp)
#            if (emp == 100):
#                print(full_url)
            print(full_url, file=f)
        f.truncate()              

parser = argparse.ArgumentParser()
parser.add_argument('-r', '--reverse_proxy', choices=[reverse_proxy_none,reverse_proxy_httpd,reverse_proxy_nginx,reverse_proxy_varnish], default=reverse_proxy_none)
#cache_parser = parser.add_mutually_exclusive_group(required=False)
parser.add_argument('-c', '--cache', choices=[cache_off,cache_on], default=cache_off)
#cache_parser.add_argument('-c', '--cache', action='store_true', help='cache requests')
#cache_parser.add_argument('-n', '--no-cache', action='store_false', help="don't cache requests")
parser.add_argument('-m', '--method', choices=[method_get, method_post], default=method_get)
#method_parser = parser.add_mutually_exclusive_group(required=False)
#method_parser.add_argument('-g', '--get',  action='store_true', help='use HTTP GET requests')
#method_parser.add_argument('-p', '--post', action='store_true', help='use HTTP POST requests')
parser.add_argument('-p', '--protocol', choices=[protocol_http, protocol_https], default=protocol_http)
#protocol_parser = parser.add_mutually_exclusive_group(required=False)
#protocol_parser.add_argument('-t', '--http',  action='store_true', help='use HTTP')
#protocol_parser.add_argument('-s', '--https', action='store_true', help='use HTTPS')        
parser.add_argument('-t', '--rest_type', choices=[rest_type_manual, rest_type_auto], default=rest_type_manual)
parser.add_argument('-o', '--port', type=int)

args = parser.parse_args()

#print(args)

setup(args.protocol, args.reverse_proxy, args.method, args.cache, args.rest_type, args.port)

