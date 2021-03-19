(** Disallows the empty string and whitespace around the edges in [of_string] and
    [t_of_sexp], but doesn't check when reading from bin_io. *)

open! Import
open Std_internal


module type S = sig
  type t = private string [@@deriving equal, hash, sexp_grammar]

  include Identifiable with type t := t
  include Quickcheckable.S with type t := t

  val arg_type : t Command.Arg_type.t

  module Stable : sig
    module V1 : sig
      type nonrec t = t [@@deriving equal, hash]

      include Stringable.S with type t := t

      include
        Stable_comparable.V1
        with type t := t
        with type comparator_witness = comparator_witness

      include Hashable.Stable.V1.S with type key := t
    end
  end
end

(** Some extra features we provide in [Make] and other functors here,
    but don't want to require of any string ID like type.
*)
module type S_with_extras = sig
  type t = private string [@@deriving typerep]

  include S with type t := t
end

module type String_id = sig
  module type S = S

  include S

  (** [Make] customizes the error messages generated by [of_string]/[of_sexp] to include
      [module_name].  It also registers a pretty printer.

      The resulting [quickcheck_generator] generates non-empty strings containing only
      printable characters, and no whitespace at the edges. *)
  module Make (M : sig
      val module_name : string
    end)
      () : S_with_extras

  (** [Make_with_validate] is like [Make], but modifies [of_string]/[of_sexp]/[bin_read_t]
      to raise if [validate] returns an error.  Before using this functor
      one should be mindful of the performance implications (the [validate] function
      will run every time an instance is created) as well as potential versioning issues
      (when [validate] changes old binaries still run the old version of the function).

      The resulting [quickcheck_generator] uses a naive [Generator.filter] to satisfy
      [validate]. For complex validation predictes, the generator may spin indefinitely
      trying to generate a satisfying string. In these cases, the client should shadow
      [quickcheck_generator] with a generator that constructs valid strings more directly.
  *)
  module Make_with_validate (M : sig
      val module_name : string
      val validate : string -> unit Or_error.t

      (** By default, String_id performs some validation of its own in addition to calling
          [validate], namely:

          - The string cannot be empty;
          - The string may not have whitespace at the beginning or the end.

          You can turn this validation off using this flag. *)
      val include_default_validation : bool
    end)
      () : S_with_extras

  (** This does what [Make] does without registering a pretty printer.  Use this when the
      module that is made is not exposed in mli.  Registering a pretty printer without
      exposing it causes an error in utop. *)
  module Make_without_pretty_printer (M : sig
      val module_name : string
    end)
      () : S_with_extras

  (** See [Make_with_validate] and [Make_without_pretty_printer] *)
  module Make_with_validate_without_pretty_printer (M : sig
      val module_name : string
      val validate : string -> unit Or_error.t
      val include_default_validation : bool
    end)
      () : S_with_extras

  module String_without_validation_without_pretty_printer : S with type t = string
end
