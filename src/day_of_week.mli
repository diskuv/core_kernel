(** For representing a day of the week. *)

type t =
  | Sun
  | Mon
  | Tue
  | Wed
  | Thu
  | Fri
  | Sat
with bin_io, compare, sexp

include Comparable.S_binable with type t := t
include Hashable.  S_binable with type t := t

(** [of_string s] accepts three-character abbreviations with any capitalization *)
include Stringable.S with type t := t

(** These use the same mapping as [Unix.tm_wday]: 0 <-> Sun, ... 6 <-> Sat *)
val of_int_exn : int -> t
val of_int     : int -> t option
val to_int     : t -> int

(** As per ISO 8601, Mon->1, Tue->2, ... Sun->7 *)
val iso_8601_weekday_number : t -> int

(** This goes forward (or backward) the specified number of weekdays *)
val shift : t -> int -> t

(** [num_days ~from ~to_] gives the number of days that must elapse from a [from] to get
    to a [to_], i.e. the smallest non-negative number [i] such that [shift from i = to_].
*)
val num_days : from:t -> to_:t -> int

val is_sun_or_sat : t -> bool

val all      : t list
val weekdays : t list (** [ Mon; Tue; Wed; Thu; Fri ] *)
val weekends : t list (** [ Sat; Sun ] *)

module Stable : sig
  module V1 : sig
    type nonrec t = t with bin_io, sexp, compare
  end
end