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
    #
    callback :my_cb, [ :nums ], :void
    attach_function :set_cb, [ :my_cb ], :void
    attach_function :register_cb, [ :int, :my_cb, :int ], :void
    attach_function :call_cb, [ ], :void
    attach_function :register_cbs, [ :int, :my_cb, :int, :my_cb, :int ], :void
    attach_function :call_cbs, [ ], :void
    #
    callback :cb_enum, [ :nums ], :nums
    callback :cb_lookup, [  ], :cb_enum
    callback :cb_int_int, [:int ], :int
    callback :cb_with_cb, [  :cb_int_int, :int ], :int
    attach_function :lookup_block_call_with_enum_arg, [ :cb_lookup, :nums ], :nums
    attach_function :callback_call_with_callback_arg, [:cb_with_cb, :cb_int_int, :int], :int
    #
    attach_function :get_cb, [ :int ], :my_cb
    #
end
#
puts "\n *** Ruby callback"
#
cb0 = Proc.new { |a| puts "\\-CB0 #{a}" }
cb1 = Proc.new { |a| puts "\\-CB1 #{a}" }
cb2 = Proc.new { |a| puts "\\-CB2 #{a}" }
#
# callbacks as parameter
Native.set_cb cb0
Native.call_cb
Native.register_cb 66, cb0, -1
Native.call_cb
Native.register_cbs 69, cb1, 666, cb2, -2
Native.call_cbs
#
CB0 = Proc.new do |enum_sym|
    v = Native.enum_type(:nums)[enum_sym]
    puts "\\-CB3 #{v}"
    v * 2
end
#
CB4 = Proc.new do
    puts "\\-CB4"
    CB0
end
#
CB6 = Proc.new do |v|
    puts " \\-CB6 #{v}"
    v*2
end
#
CB5 = Proc.new do |cb,val|
    puts "\\-CB5 #{val}"
    cb.call(val)
end
#
cb = Native.get_cb 0
puts "\\-CB1 #{cb.call(:sixxx)}"
cb = Native.get_cb 1
puts "\\-CB2 #{cb.call(9)}"
#
puts Native.lookup_block_call_with_enum_arg CB4, 2
puts Native.lookup_block_call_with_enum_arg CB4, :three
#
puts Native.callback_call_with_callback_arg(CB5, CB6, 666)
#
