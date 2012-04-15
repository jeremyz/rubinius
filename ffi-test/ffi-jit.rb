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
    enum :enum, [ :three, 3, :four, :five, :zero, 0, :one, :two, :sixxx,6, :seven, :eight, :nine, :ten ]
    attach_function :set_value, [ :enum, :int ], :void
    attach_function :get_value, [ :int ], :enum
    #
end
#
puts " *** JIT check"
#
def check_levels verbose
    enum = Native.enum_type(:enum)
    10.downto(0) do |n|
        Native.set_value n, verbose
        s = Native.get_value(verbose)
        if enum[s]!=n
            puts "ERROR 3 #{s}!=#{enum.symbol(n)}"
            exit 1
        end
    end
    Native.enum_type(:enum).symbols.each do |s|
        Native.set_value s, verbose
        sleep 0.1
        if Native.get_value(verbose)!=s
            puts "ERROR 4 #{Native.get_value(verbose)}!=#{s}"
            exit 1
        end
    end
end
#
def check n
    i=0
    while i<n
        printf "%02d ", i
        check_levels 0#(i>15 ? 1 : 0 )
        i+=1
    end
end
#
puts "\ncheck JIT ***"
#
check 30
#
