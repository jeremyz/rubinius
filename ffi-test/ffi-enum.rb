#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
require 'ffi'
#
module Native
    #
    extend FFI::Library
    ffi_lib 'libclib.so'
    #
    enum :nums, [ :three, 3, :four, :five, :zero, 0, :one, :two, :sixxx,6, :seven, :eight, :nine, :ten ]
    attach_function :set_value, [ :nums, :int ], :void
    attach_function :get_value, [ :int ], :nums
    callback :block_cb, [ :nums ], :nums
    attach_function :block_call_with_enum_arg, [ :block_cb, :nums ], :nums
    #
end
#
puts "\n *** Ruby enum"
#
# check enum initialisation
[ :zero, :one, :two, :three, :four, :five, :sixxx, :seven, :eight, :nine, :ten ].zip([0,1,2,3,4,5,6,7,8,9,10]) do |s,v|
    if Native.enum_type(:nums)[s] !=v
        puts "ERROR 0"
        exit 1
    end
end
#
# check enum as parameter and return value
Native.set_value :sixxx, 1
if Native.get_value(1)!=:sixxx
    puts "ERROR 1"
    exit 1
end
# check int as parameter and enum as return value
Native.set_value 9, 1
if Native.get_value(1)!=:nine
    puts "ERROR 2"
    exit 1
end
#
CB2 = Proc.new do |e|
    enum = Native.enum_type(:nums)
    puts "\\-CB2 #{enum[e]}"
    enum.symbol enum[e]*2
end
# int -> CLIB int -> BLOCK enum -> CLIB int -> enum
val = Native.block_call_with_enum_arg(CB2, 2)
puts "|-- #{Native.enum_type(:nums)[val]}"
puts "ERROR 3 : #{val}" if val!=:four
# enum -> CLIB int -> BLOCK enum -> CLIB int -> enum
val = Native.block_call_with_enum_arg(CB2, :three)
puts "|-- #{Native.enum_type(:nums)[val]}"
puts "ERROR 4 : #{val}" if val!=:sixxx
#
