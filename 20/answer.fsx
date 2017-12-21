#r "packages/FSharp.Text.RegexProvider/lib/net40/FSharp.Text.RegexProvider.dll"

open System

open FSharp.Text.RegexProvider

type LineRegex = Regex< "p=<(?<px>[-0-9]+),(?<py>[-0-9]+),(?<pz>[-0-9]+)>, v=<(?<vx>[-0-9]+),(?<vy>[-0-9]+),(?<vz>[-0-9]+)>, a=<(?<ax>[-0-9]+),(?<ay>[-0-9]+),(?<az>[-0-9]+)>" > 

let matchline line = 
    let m = LineRegex().TypedMatch(line)
    let v (regGroup : Text.RegularExpressions.Group) = regGroup.Value |> int
    ((v m.px, v m.py, v m.pz), (v m.vx, v m.vy, v m.vz), (v m.ax, v m.ay, v m.az))

let add (x1, y1, z1) (x2, y2, z2) = (x1+x2, y1+y2, z1+z2)

let lines =
    Seq.initInfinite (fun _ -> System.Console.In.ReadLine())
 |> Seq.takeWhile(isNull >> not)
 |> Seq.map matchline
 |> List.ofSeq

let tick (p, v, a) =
    let v' = add v a
    let p' = add p v'
    (p', v', a)

let dist (x, y, z) = abs x + abs y + abs z
let pos (p, _, _) = p
let dist' = dist << pos

let dedupPos elts =
    let (_, dups) = 
        elts 
            |> List.map pos
            |> List.fold (fun (seen, dups) el -> 
                (Set.add el seen,
                    if Set.contains el seen then Set.add el dups else dups)
                ) (Set.empty, Set.empty)
    elts |> List.filter (pos >> (fun p -> Set.contains p dups) >> not)

let lines' f =
    let rec loop x i = 
        match i with
        | 0 -> x
        | i -> loop (List.map tick x |> f) (i-1)
    loop lines 1000

let answer = List.minBy dist' (lines' id)
let answerNo = List.findIndex (fun x -> x = answer) (lines' id)

printf "Answer 1: %d\n" answerNo
let answer2 = lines' dedupPos |> List.length
printf "Answer 1: %d\n" answer2