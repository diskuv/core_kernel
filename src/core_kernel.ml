(** [Core_kernel] greatly expands the functionality available in Base while still
    remaining platform-agnostic.  Core_kernel changes more frequently (i.e., is less
    stable) than Base.

    Some modules are mere extensions of their counterparts in Base, usually adding generic
    functionality by including functors that make them binable, comparable, sexpable,
    blitable, etc.  The bulk of Core_kernel, though, is modules providing entirely new
    functionality. *)

open! Import


module Applicative = Applicative
module Arg = Arg
module Array = Array
module Avltree = Avltree
module Backtrace = Backtrace
module Bag = Bag
module Bigbuffer = Bigbuffer
module Bigstring = Bigstring
module Bigsubstring = Bigsubstring
module Bin_prot = Core_bin_prot
module Binable = Binable
module Binary_search = Binary_search
module Binary_searchable = Binary_searchable
module Blang = Blang
module Blit = Blit
module Bool = Bool
module Bounded_index = Bounded_index
module Buffer = Base.Buffer
module Byte_units = Byte_units
module Bytes = Bytes
module Caml = Caml
module Char = Char
module Command = Command
module Comparable = Comparable
module Comparator = Comparator
module Comparisons = Comparisons
module Container = Container
module Container_intf = Container_intf
module Continue_or_stop = Continue_or_stop
module Core_kernel_stable = Stable
module Date = Date
module Day_of_week = Day_of_week
module Debug = Debug
module Deque = Deque
module Deriving_hash = Deriving_hash
module Digest = Md5 [@@ocaml.deprecated "[since 2017-05] Use Md5 instead."]
module Doubly_linked = Doubly_linked
module Either = Either
module Ephemeron = Ephemeron
module Equal = Equal
module Error = Error
module Exn = Base.Exn
module Expect_test_config = Expect_test_config
module Fdeque = Fdeque
module Field = Field
module Filename = Filename
module Float = Float
module Float_with_finite_only_serialization = Float_with_finite_only_serialization
module Floatable = Floatable
module Fn = Fn
module Formatter = Formatter
module Fqueue = Fqueue
module Gc = Gc
module Hash = Hash
module Hash_queue = Hash_queue
module Hash_set = Hash_set
module Hashable = Hashable
module Hashtbl = Hashtbl
module Hashtbl_intf = Hashtbl_intf
module Heap_block = Heap_block
module Hexdump = Hexdump
module Hexdump_intf = Hexdump_intf
module Host_and_port = Host_and_port
module Identifiable = Identifiable
module Immediate_option = Immediate_option
module Immediate_option_intf = Immediate_option_intf
module In_channel = In_channel
module Info = Info
module Int = Int
module Int32 = Int32
module Int63 = Int63
module Int64 = Int64
module Int_conversions = Int_conversions
module Int_intf = Int_intf
module Int_math = Int_math
module Intable = Intable
module Interfaces = Interfaces
module Invariant = Invariant
module Lazy = Lazy
module Linked_queue = Linked_queue
module List = List
module Map = Map
module Map_intf = Map_intf
module Maybe_bound = Maybe_bound
module Md5 = Md5
module Memo = Memo
module Monad = Monad
module Month = Month
module Nativeint = Nativeint
module No_polymorphic_compare = No_polymorphic_compare
module Nothing = Nothing
module Only_in_test = Only_in_test
module Option = Option
module Option_array = Option_array
module Optional_syntax = Optional_syntax
module Optional_syntax_intf = Optional_syntax_intf
module Or_error = Or_error
module Ordered_collection_common = Ordered_collection_common
module Ordering = Ordering
module Out_channel = Out_channel
module Percent = Percent
module Perms = Perms
module Pid = Pid
module Poly = Poly
module Polymorphic_compare = Poly [@@deprecated "[since 2018-11] use [Poly] instead"]

module Popcount = Base.Popcount
[@@warning "-3"]
[@@deprecated "[since 2018-10] use [popcount] functions in individual int modules"]

module Pretty_printer = Pretty_printer
module Printexc = Printexc
module Printf = Printf
module Queue = Queue
module Quickcheck = Quickcheck
module Quickcheck_intf = Quickcheck_intf
module Quickcheckable = Quickcheckable
module Random = Base.Random
module Ref = Ref
module Result = Result
module Robustly_comparable = Robustly_comparable
module Sequence = Sequence
module Set = Set
module Set_intf = Set_intf
module Set_once = Set_once
module Sexp_maybe = Sexp.Sexp_maybe

module Sexp = Sexp
module Sexpable = Sexpable
module Sign = Sign
module Sign_or_nan = Sign_or_nan
module Source_code_position = Source_code_position
module Splittable_random = Splittable_random
module Stable_comparable = Stable_comparable
module Stable_unit_test = Stable_unit_test
module Stack = Stack
module Staged = Base.Staged
module String = String
module String_id = String_id
module Stringable = Stringable
module Substring = Substring
module Substring_intf = Substring_intf
module Sys = Sys
module Time = Time_float
module Time_ns = Time_ns
module Tuple = Tuple
module Tuple2 = Tuple.T2
module Tuple3 = Tuple.T3
module Type_equal = Type_equal
module Type_immediacy = Type_immediacy
module Uchar = Uchar
module Uniform_array = Uniform_array
module Union_find = Union_find
module Unique_id = Unique_id
module Unit = Unit
module Unit_of_time = Unit_of_time
module Univ_map = Univ_map

module Unix = struct end
[@@deprecated
  "[since 2020-03] Core_kernel shadows Unix. Use Core.Unix, which overrides some of \
   Unix's behavior. If necessary, Unix is available and unshadowed as Caml_unix."]

module Validate = Validate
module Validated = Validated
module Variant = Variant
module Weak = Weak
module With_return = With_return
module Word_size = Word_size

module type Unique_id = Unique_id.Id

include T (** @open *)

include Std_internal
include Not_found

(** {2 Top-level values} *)

type 'a _maybe_bound = 'a Maybe_bound.t =
  | Incl of 'a
  | Excl of 'a
  | Unbounded

let am_running_inline_test = am_running_inline_test
let am_running_test = am_running_test
let does_raise = Exn.does_raise
let sec = Time_float.Span.of_sec

(** We perform these side effects here because we want them to run for any code that uses
    [Core_kernel].  If this were in another module in [Core_kernel] that was not used in
    some program, then the side effects might not be run in that program.  This will run
    as long as the program refers to at least one value directly in [Std_kernel];
    referring to values in [Std_kernel.Bool], for example, is not sufficient. *)
let () = Exn.initialize_module ()

(** To be used in implementing Core, but not by end users. *)
module Core_kernel_private = struct
  module Digit_string_helpers = Digit_string_helpers
  module Time_zone = Zone
  module Ofday_helpers = Ofday_helpers
  module Span_float = Span_float

  module Bigbuffer_internal = Bigbuffer_internal
  module Stable_internal = Stable_internal
  module Std_internal = Std_internal

  module Time_ns_alternate_sexp = Time_ns_alternate_sexp
end

let ( ^/ ) = Filename.concat
