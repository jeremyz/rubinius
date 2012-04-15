#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
module Native
    #
    extend FFI::Library
    #
    ffi_lib 'elementary-ver-pre-svn-09.so.0'
    #
    attach_variable :elm_version, :pointer
    attach_function :elm_init, [ :int, :pointer ], :int
    attach_function :elm_shutdown, [  ], :int
    attach_function :elm_run, [  ], :void
    attach_function :elm_exit, [  ], :void
    #
    typedef :pointer, :evas_object
    callback :evas_smart_cb, [ :pointer, :evas_object, :pointer ], :void
    attach_function :evas_object_show, [ :evas_object ], :void
    attach_function :evas_object_move, [ :evas_object, :int, :int ], :void
    attach_function :evas_object_resize, [ :evas_object, :int, :int ], :void
    attach_function :evas_object_size_hint_weight_set, [ :evas_object, :double, :double ], :void
    attach_function :evas_object_smart_callback_add, [ :evas_object, :string, :evas_smart_cb, :pointer ], :void
    #
    attach_function :elm_object_part_text_set, [ :evas_object, :string, :string ], :void
    #
    enum :elm_win_type, [ :elm_win_basic, :elm_win_dialog_basic, :elm_win_desktop, :elm_win_dock, :melm_win_toolbar, :elm_win_menu ]
    attach_function :elm_win_add, [ :evas_object, :string, :elm_win_type ], :evas_object
    attach_function :elm_win_title_set, [ :evas_object, :string ], :void
    attach_function :elm_win_resize_object_add, [ :evas_object, :evas_object ], :void
    attach_function :elm_bg_add, [ :evas_object ], :evas_object
    attach_function :elm_label_add, [ :evas_object ], :evas_object
    #
    class VersionStruct < FFI::Struct
        layout  :major,     :int,
                :minor,     :int,
                :micro,     :int,
                :revision,  :int

        def full
            [:major,:minor,:micro,:revision].collect { |e| self[e].to_s }.join '.'
        end
    end
    def self.version
        VersionStruct.new(Native.elm_version).full
    end
    #
end
#
puts "Elementary #{Native.version}"
#
Native.elm_init 0, FFI::MemoryPointer::NULL
#
win_del = Proc.new { |data,evas_object,event_info|
    Native.elm_exit;
}
#
win = Native.elm_win_add nil, "App name", :elm_win_basic
Native.elm_win_title_set win, "Window title"
Native.evas_object_smart_callback_add win, "delete,request", win_del, nil
#
bg = Native.elm_bg_add win
Native.evas_object_size_hint_weight_set bg, 1.0, 1.0
Native.elm_win_resize_object_add win, bg
Native.evas_object_show bg
#
lb = Native.elm_label_add win
Native.elm_object_part_text_set lb, nil, "Hello World"
Native.evas_object_size_hint_weight_set lb, 1.0, 1.0
Native.elm_win_resize_object_add win, lb
Native.evas_object_show lb
#
Native.evas_object_move win, 300, 300
Native.evas_object_resize win, 200, 100
#
Native.evas_object_show win
#
Native.elm_run
Native.elm_shutdown
#
puts "all good"
#
# EOF
