(**************************************************************************)
(*                                                                        *)
(*  VOCaL -- A Verified OCaml Library                                     *)
(*                                                                        *)
(*  Copyright (c) 2020 The VOCaL Project                                  *)
(*                                                                        *)
(*  This software is free software, distributed under the MIT license     *)
(*  (as described in file LICENSE enclosed).                              *)
(**************************************************************************)

(*@ open Bag   *)

module Make (X: sig (* FIXME: use ComparableType.S instead *)
  type t

  (*@ function cmp: t -> t -> int *)

  (*@ axiom is_pre_order: Order.is_pre_order cmp *)

  val compare : t -> t -> int
    (*@ r = compare x y
          ensures r = cmp x y *)
end) : sig

  type elt = X.t

  type heap
  (*@ model bag : elt bag *)

  val empty : unit -> heap
  (*@ h = empty ()
        ensures card h.bag = 0
        ensures forall x. nb_occ x h.bag = 0 *)

  val is_empty : heap -> bool
  (*@ b = is_empty h
        ensures b <-> h.bag = empty_bag *)

  val merge : heap -> heap -> heap
  (*@ h = merge h1 h2
        ensures card h.bag = card h1.bag + card h2.bag
        ensures forall x. nb_occ x h.bag = nb_occ x h1.bag + nb_occ x h2.bag *)

  val insert : elt -> heap -> heap
  (*@ h' = insert x h
        ensures nb_occ x h'.bag = nb_occ x h.bag + 1
        ensures forall y. y <> x -> nb_occ y h'.bag = nb_occ y h.bag
        ensures card h'.bag = card h.bag + 1 *)

  (*@ predicate mem        (x: elt) (h: heap) = nb_occ x h.bag > 0 *)
  (*@ predicate is_minimum (x: elt) (h: heap) =
        mem x h /\ forall e. mem e h -> X.cmp x e <= 0 *)

  (*@ function minimum (h: heap) : elt *)
  (*@ axiom min_def: forall h. 0 < card h.bag -> is_minimum (minimum h) h *)

  val find_min : heap -> elt
  (*@ x = find_min h
        requires card h.bag > 0
        ensures  x = minimum h *)

  val delete_min : heap -> heap
  (*@ h' = delete_min h
        requires card h.bag > 0
        ensures  let x = minimum h in nb_occ x h'.bag = nb_occ x h.bag - 1
        ensures  forall y. y <> minimum h -> nb_occ y h'.bag = nb_occ y h.bag
        ensures  card h'.bag = card h.bag - 1 *)
end
