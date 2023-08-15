@doc """
Matrices for the homalg project
"""
module MatricesForHomalg

import Base: getindex

import AbstractAlgebra
import AbstractAlgebra: ZZ, QQ, matrix

export ZZ, QQ

TypeOfMatrixForHomalg = AbstractAlgebra.Generic.MatSpaceElem

## Constructors of homalg matrices

"""
    HomalgMatrix(L, r, c, R)

Construct a (r x c)-matrix over the ring R with L as list of entries

```jldoctest
julia> mat = HomalgMatrix([1,2,3,4,5,6], 2, 3, ZZ)
[1   2   3]
[4   5   6]
```
"""
function HomalgMatrix(entries, r, c, R)::TypeOfMatrixForHomalg
    return matrix(R, r, c, entries)
end

"""
    HomalgIdentityMatrix(r, R)

Construct a (r x r)-identity matrix over the ring R

```jldoctest
julia> mat = HomalgIdentityMatrix(3, ZZ)
[1   0   0]
[0   1   0]
[0   0   1]
```
"""
function HomalgIdentityMatrix(r, R)::TypeOfMatrixForHomalg
    return AbstractAlgebra.identity_matrix(R, r)
end

"""
    HomalgZeroMatrix(r, c, R)

Construct a (r x c)-zero matrix over the ring R

```jldoctest
julia> mat = HomalgZeroMatrix(3, 2, ZZ)
[0   0]
[0   0]
[0   0]
```
"""
function HomalgZeroMatrix(r, c, R)::TypeOfMatrixForHomalg
    return AbstractAlgebra.zero_matrix(R, r, c)
end

"""
    HomalgRowVector(L, c, R)

Construct a (1 x c)-matrix over the ring R with entries in the list L

```jldoctest
julia> mat = HomalgRowVector(1:5, 5, ZZ)
[1   2   3   4   5]
```
"""
function HomalgRowVector(entries, c, R)::TypeOfMatrixForHomalg
    return HomalgMatrix(entries, 1, c, R)
end

"""
    HomalgRowVector(L, R)

Construct a (1 x c)-matrix over the ring R with entries in the list L, where c = length(L)

```jldoctest
julia> mat = HomalgRowVector(1:5, ZZ)
[1   2   3   4   5]
```
"""
function HomalgRowVector(entries, R)::TypeOfMatrixForHomalg
    return HomalgRowVector(entries, length(entries), R)
end

"""
    HomalgColumnVector(L, r, R)

Construct a (r x 1)-matrix over the ring R with entries in the list L

```jldoctest
julia> mat = HomalgColumnVector(1:5, 5, ZZ)
[1]
[2]
[3]
[4]
[5]
```
"""
function HomalgColumnVector(entries, r, R)::TypeOfMatrixForHomalg
    return HomalgMatrix(entries, r, 1, R)
end

"""
    HomalgColumnVector(L, r, R)

Construct a (r x 1)-matrix over the ring R with entries in the list L, where r = length(L)

```jldoctest
julia> mat = HomalgColumnVector(1:5, ZZ)
[1]
[2]
[3]
[4]
[5]
```
"""
function HomalgColumnVector(entries, R)::TypeOfMatrixForHomalg
    return HomalgColumnVector(entries, length(entries), R)
end

"""
    HomalgDiagonalMatrix(L, R)

Construct a diagonal matrix over the ring R using the list L of diagonal entries

```jldoctest
julia> mat = HomalgDiagonalMatrix(1:5, ZZ)
[1   0   0   0   0]
[0   2   0   0   0]
[0   0   3   0   0]
[0   0   0   4   0]
[0   0   0   0   5]
```
"""
function HomalgDiagonalMatrix(diagonal_entries, R)::TypeOfMatrixForHomalg
    return AbstractAlgebra.block_diagonal_matrix(map(a->HomalgMatrix([a],1,1,R), diagonal_entries))
end

"""
    R * mat

Rewrite the matrix mat over the ring R (if possible)

```jldoctest
julia> mat = HomalgMatrix([1,2,3,4,5,6], 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> QQ * mat
[1//1   2//1   3//1]
[4//1   5//1   6//1]

julia> qmat = QQ * mat
[1//1   2//1   3//1]
[4//1   5//1   6//1]

julia> ZZ * qmat == mat
true
```
"""
Base.:*(R, mat) = AbstractAlgebra.change_base_ring(R, mat)

export HomalgMatrix, HomalgIdentityMatrix, HomalgZeroMatrix, HomalgRowVector, HomalgColumnVector, HomalgDiagonalMatrix

## Properties of homalg matrices

"""
    IsOne(mat)

Return true if mat is an identity matrix, otherwise false

```jldoctest
julia> mat = HomalgIdentityMatrix(3, ZZ)
[1   0   0]
[0   1   0]
[0   0   1]

julia> IsOne(mat)
true
```
"""
function IsOne(mat)::Bool
    return AbstractAlgebra.isone(mat)
end

"""
    IsZero(mat)

Return true if mat is a zero matrix, otherwise false

```jldoctest
julia> mat = HomalgZeroMatrix(3, 2, ZZ)
[0   0]
[0   0]
[0   0]

julia> IsZero(mat)
true
```
"""
function IsZero(mat)::Bool
    return AbstractAlgebra.iszero(mat)
end

"""
    IsEmptyMatrix(mat)

Return true if mat does not contain any entry, otherwise false

```jldoctest
julia> mat = HomalgMatrix([], 0, 0, ZZ)
0 by 0 empty matrix

julia> IsEmptyMatrix(mat)
true
```
"""
function IsEmptyMatrix(mat)::Bool
    return isempty(mat)
end

"""
    IsSymmetricMatrix(mat)

Return true if the matrix mat is symmetric with respect to its main diagonal, otherwise false

```jldoctest
julia> mat = HomalgMatrix([1,2,3,2,4,5,3,5,6], 3, 3, ZZ)
[1   2   3]
[2   4   5]
[3   5   6]

julia> IsSymmetricMatrix(mat)
true
```
"""
function IsSymmetricMatrix(mat)::Bool
    return AbstractAlgebra.is_symmetric(mat)
end

export IsOne, IsZero, IsEmptyMatrix, IsSymmetricMatrix

## Attributes of homalg matrices

"""
    HomalgRing(mat)

Return the ring underlying the matrix mat.

```jldoctest
julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> HomalgRing(mat)
Integers

julia> mat = HomalgMatrix(1:6, 2, 3, QQ)
[1//1   2//1   3//1]
[4//1   5//1   6//1]

julia> HomalgRing(mat)
Rationals
```
"""
function HomalgRing(mat)
    return AbstractAlgebra.base_ring(mat)
end

"""
    NumberRows(mat)

The number of rows of the matrix mat

```jldoctest
julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> NumberRows(mat)
2
```
"""
function NumberRows(mat)::Int64
    return AbstractAlgebra.nrows(mat)
end

"""
    NumberColumns(mat)

The number of columns of the matrix mat

```jldoctest
julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> NumberColumns(mat)
3
```
"""
function NumberColumns(mat)::Int64
    return AbstractAlgebra.ncols(mat)
end

"""
    TransposedMatrix(mat)

Return the transposed matrix of mat

```jldoctest
julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> TransposedMatrix(mat)
[1   4]
[2   5]
[3   6]
```
"""
function TransposedMatrix(mat)::TypeOfMatrixForHomalg
    return Base.transpose(mat)
end

"""
    ConvertMatrixToRow(mat)

Unfold the matrix M row-wise into a row.

```jldoctest
julia> mat = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> ConvertMatrixToRow(mat)
[2   3   4   5   6   7]

```
"""
function ConvertMatrixToRow(mat)::TypeOfMatrixForHomalg
    return UnionOfColumns(HomalgRing(mat), 1, map(i -> CertainRows(mat, i:i), 1:NumberRows(mat)))
end

"""
    ConvertMatrixToColumn(mat)

Unfold the matrix M column-wise into a column.

```jldoctest
julia> mat = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> ConvertMatrixToColumn(mat)
[2]
[4]
[6]
[3]
[5]
[7]

```
"""
function ConvertMatrixToColumn(mat)::TypeOfMatrixForHomalg
    return UnionOfRows(HomalgRing(mat), 1, map(j -> CertainColumns(mat, [j]), 1:NumberColumns(mat)))
end

"""
    RowReducedEchelonForm(mat)

Return the reduced row-echelon form and the rank of the matrix mat.

```jldoctest
julia> mat = HomalgMatrix(reverse(1:9), 3, 3, ZZ)
[9   8   7]
[6   5   4]
[3   2   1]

julia> RowReducedEchelonForm(mat)
([3 0 -3; 0 1 2; 0 0 0], 2)

julia> mat = HomalgMatrix(reverse(1:9), 3, 3, QQ)
[9//1   8//1   7//1]
[6//1   5//1   4//1]
[3//1   2//1   1//1]

julia> RowReducedEchelonForm(mat)
([1 0 -1; 0 1 2; 0 0 0], 2)
"""
function RowReducedEchelonForm(mat::AbstractAlgebra.Generic.MatSpaceElem{BigInt})::Tuple{TypeOfMatrixForHomalg, Int64}
    hnf = AbstractAlgebra.hnf(mat)
    rank = AbstractAlgebra.rank(hnf)
    return hnf, rank
end

function RowReducedEchelonForm(mat::AbstractAlgebra.Generic.MatSpaceElem{Rational{BigInt}})::Tuple{TypeOfMatrixForHomalg, Int64}
    rank, rref = AbstractAlgebra.rref(mat)
    return rref, rank
end

"""
    BasisOfRows(mat)

Return the triangular form of mat

```jldoctest
julia> mat = HomalgMatrix(1:9, 3, 3, ZZ)
[1   2   3]
[4   5   6]
[7   8   9]

julia> BasisOfRows(mat)
[1   2   3]
[0   3   6]

julia> mat = HomalgMatrix(1:9, 3, 3, QQ)
[1//1   2//1   3//1]
[4//1   5//1   6//1]
[7//1   8//1   9//1]

julia> BasisOfRows(mat)
[1//1   0//1   -1//1]
[0//1   1//1    2//1]
```
"""
function BasisOfRows(mat)::TypeOfMatrixForHomalg
    rref, rank = RowReducedEchelonForm(mat)
    return rref[1:rank, :]
end

"""
    BasisOfColumns(mat)

Return the triangular form of mat

```jldoctest
julia> mat = HomalgMatrix(1:9, 3, 3, ZZ)
[1   2   3]
[4   5   6]
[7   8   9]

julia> BasisOfColumns(mat)
[1   0]
[1   3]
[1   6]

julia> mat = HomalgMatrix(1:9, 3, 3, QQ)
[1//1   2//1   3//1]
[4//1   5//1   6//1]
[7//1   8//1   9//1]

julia> BasisOfColumns(mat)
[ 1//1   0//1]
[ 0//1   1//1]
[-1//1   2//1]
```
"""
function BasisOfColumns(mat)::TypeOfMatrixForHomalg
    return TransposedMatrix(BasisOfRows(TransposedMatrix(mat)))
end

"""
    ZeroRows(mat)

Return a (possibly empty) list of positive integers. The list of zero rows of the matrix A.

```jldoctest
julia> mat = HomalgMatrix(4:9, 3, 2, ZZ)
[4   5]
[6   7]
[8   9]

julia> ZeroRows(mat)
Int64[]

julia> mat = HomalgMatrix([0, 2, 6, 0, 0, 0], 3, 2, ZZ)
[0   2]
[6   0]
[0   0]

julia> ZeroRows(mat)
1-element Vector{Int64}:
 3

julia> mat = HomalgZeroMatrix(3,3,ZZ)
[0   0   0]
[0   0   0]
[0   0   0]

julia> ZeroRows(mat)
3-element Vector{Int64}:
 1
 2
 3
```
"""
function ZeroRows(mat)::Vector{Int64}
    return filter(i -> IsZero(CertainRows(mat, [i])), 1:NumberRows(mat))
end

"""
    ZeroColumns(mat)

Return a (possibly empty) list of positive integers. The list of zero columns of the matrix A.

```jldoctest
julia> mat = HomalgMatrix(4:9, 2, 3, ZZ)
[4   5   6]
[7   8   9]

julia> ZeroColumns(mat)
Int64[]

julia> mat = HomalgMatrix([0, 2, 6, 0, 0, 0], 2, 3, ZZ)
[0   2   6]
[0   0   0]

julia> ZeroColumns(mat)
1-element Vector{Int64}:
 1

julia> mat = HomalgZeroMatrix(3,3,ZZ)
[0   0   0]
[0   0   0]
[0   0   0]

julia> ZeroColumns(mat)
3-element Vector{Int64}:
 1
 2
 3
```
"""
function ZeroColumns(mat)::Vector{Int64}
    return filter(i -> IsZero(CertainColumns(mat, [i])), 1:NumberColumns(mat))
end

"""
    FirstZeroRow(mat)

Return a positive integer of the first zero row.

```jldoctest
julia> mat = HomalgMatrix(4:9, 3, 2, ZZ)
[4   5]
[6   7]
[8   9]

julia> FirstZeroRow(mat)
4

julia> mat = HomalgMatrix([0, 2, 6, 0, 0, 0], 3, 2, ZZ)
[0   2]
[6   0]
[0   0]

julia> FirstZeroRow(mat)
3

julia> mat = HomalgMatrix([0, 0, 6, 0, 0, 0], 3, 2, ZZ)
[0   0]
[6   0]
[0   0]

julia> FirstZeroRow(mat)
1
```
"""
function FirstZeroRow(mat)::Int64
    first_zero_row = findfirst(i -> IsZero(CertainRows(mat, [i])), 1:NumberRows(mat))
    if first_zero_row === nothing
        return 1+NumberRows(mat)
    end
    return first_zero_row
end

"""
    FirstZeroColumn(mat)

Return a positive integer of the first zero column.

```jldoctest
julia> mat = HomalgMatrix(4:9, 2, 3, ZZ)
[4   5   6]
[7   8   9]

julia> FirstZeroColumn(mat)
4

julia> mat = HomalgMatrix([0, 2, 0, 0, 0, 0], 2, 3, ZZ)
[0   2   0]
[0   0   0]

julia> FirstZeroColumn(mat)
1

julia> mat = HomalgZeroMatrix(3,3,ZZ)
[0   0   0]
[0   0   0]
[0   0   0]

julia> FirstZeroColumn(mat)
1
```
"""
function FirstZeroColumn(mat)::Int64
    first_zero_column = findfirst(i -> IsZero(CertainColumns(mat, [i])), 1:NumberColumns(mat))
    if first_zero_column === nothing
        return 1+NumberColumns(mat)
    end
    return first_zero_column
end

"""
    SyzygiesOfRows(mat)

Return a homalg matrix.
Let R be the ring over which M is defined (R:= HomalgRing( M )). The matrix of row syzygies SyzygiesGeneratorsOfRows( M ) is a matrix whose rows span the left kernel of M,
i.e. the R-submodule of the free left module R(1xNrRows(M)) consisting of all rows X satisfying XM=0

```jldoctest
julia> mat = HomalgMatrix(4:9, 3, 2, ZZ)
[4   5]
[6   7]
[8   9]

julia> s = SyzygiesOfRows(mat)
[1   -2   1]

julia> s*mat
[0   0]
```
"""
function SyzygiesOfRows(A)::TypeOfMatrixForHomalg
    ring = HomalgRing(A)
    nr_rows = NumberRows(A)
    nr_cols = NumberColumns(A)

    ident_mat_a = HomalgIdentityMatrix(nr_rows, ring)

    temp_mat = UnionOfColumns(ring, nr_rows, [A, ident_mat_a])

    resulting_mat = BasisOfRows(temp_mat)

    BA = resulting_mat[:, 1 : nr_cols]

    s = FirstZeroRow(BA)

    return resulting_mat[s:nr_rows, nr_cols + 1 : nr_cols + nr_rows]
end

"""
    SyzygiesOfColumns(mat)

Return a homalg matrix.
Let R be the ring over which M is defined (R:=HomalgRing( M )). The matrix of column syzygies SyzygiesGeneratorsOfColumns( M ) is a matrix whose columns span the right kernel of M,
i.e. the R-submodule of the free right module R(NrColumns(M)x1) consisting of all columns X satisfying MX=0

```jldoctest
julia> mat = TransposedMatrix(HomalgMatrix(4:9, 3, 2, ZZ))
[4   6   8]
[5   7   9]

julia> s = SyzygiesOfColumns(mat)
[ 1]
[-2]
[ 1]

julia> mat*s
[0]
[0]
```
"""
function SyzygiesOfColumns(A)::TypeOfMatrixForHomalg
    return TransposedMatrix(SyzygiesOfRows(TransposedMatrix(A)))
end

export HomalgRing, NumberRows, NumberColumns, TransposedMatrix, ConvertMatrixToRow, ConvertMatrixToColumn,
    RowReducedEchelonForm, BasisOfRows, BasisOfColumns, ZeroRows, ZeroColumns, FirstZeroRow, FirstZeroColumn,
    SyzygiesOfRows, SyzygiesOfColumns

## Operations of homalg matrices

"""
    UnionOfRows(R, nr_cols, list)

Return the matrices in list stacked, where all of them have same number of columns nr_cols.

```jldoctest
julia> UnionOfRows(ZZ, 3, [])
0 by 3 empty matrix

julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> UnionOfRows(ZZ, 3, [mat, mat])
[1   2   3]
[4   5   6]
[1   2   3]
[4   5   6]
```
"""
function UnionOfRows(R, nr_cols, list)::TypeOfMatrixForHomalg
    if length(list) == 0
        return HomalgZeroMatrix(0, nr_cols, R)
    end

    return vcat(list...)
end

"""
    UnionOfColumns(R, nr_rows, list)

Return the matrices in list augmented, where all of them have same number of rows nr_rows.
.

```jldoctest
julia> UnionOfColumns(ZZ, 2, [])
2 by 0 empty matrix

julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> UnionOfColumns(ZZ, 2, [mat, mat])
[1   2   3   1   2   3]
[4   5   6   4   5   6]
```
"""
function UnionOfColumns(R, nr_rows, list)::TypeOfMatrixForHomalg
    if length(list) == 0
        return HomalgZeroMatrix(nr_rows, 0, R)
    end

    return hcat(list...)
end

"""
    CertainColumns(mat, list)

Return the matrix of which the i-th column is the k-th column of the homalg matrix M, where k=list[i].

```jldoctest
julia> mat = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> CertainColumns(mat, [2, 2, 1])
[2   2   1]
[5   5   4]

julia> CertainColumns(mat, [])
2 by 0 empty matrix

julia> CertainColumns(mat, 4:3)
2 by 0 empty matrix
```
"""
function CertainColumns(mat, list)::TypeOfMatrixForHomalg
    if length(list) == 0
        return HomalgZeroMatrix(NumberRows(mat), 0, HomalgRing(mat))
    end
    return mat[:, list]
end

"""
    CertainRows(mat, list)

Return the matrix of which the i-th row is the k-th row of the homalg matrix M, where k=list[i].

```jldoctest
julia> mat = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> CertainRows(mat, [2, 2, 1])
[4   5]
[4   5]
[2   3]

julia> CertainRows(mat, [])
0 by 2 empty matrix

julia> CertainRows(mat, 4:3)
0 by 2 empty matrix
```
"""
function CertainRows(mat, list)::TypeOfMatrixForHomalg
    if length(list) == 0
        return HomalgZeroMatrix(0, NumberColumns(mat), HomalgRing(mat))
    end
    return mat[list, :]
end

"""
    KroneckerMat(mat1, mat2)

Return the Kronecker (or tensor) product of the two homalg matrices mat1 and mat2.

```jldoctest
julia> mat1 = HomalgMatrix(1:6, 2, 3, ZZ)
[1   2   3]
[4   5   6]

julia> mat2 = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> KroneckerMat(mat1, mat2)
[ 2    3    4    6    6    9]
[ 4    5    8   10   12   15]
[ 6    7   12   14   18   21]
[ 8   12   10   15   12   18]
[16   20   20   25   24   30]
[24   28   30   35   36   42]

julia> KroneckerMat(mat2, mat1)
[ 2    4    6    3    6    9]
[ 8   10   12   12   15   18]
[ 4    8   12    5   10   15]
[16   20   24   20   25   30]
[ 6   12   18    7   14   21]
[24   30   36   28   35   42]

```
"""
function KroneckerMat(mat1, mat2)::TypeOfMatrixForHomalg
    return AbstractAlgebra.kronecker_product(mat1, mat2)
end

"""
    SafeRightDivide(B, A, L)

Returns: a homalg matrix

Same as RightDivide, but asserts that the result is not fail.

```jldoctest
julia> A = HomalgMatrix(1:9, 3, 3, ZZ)
[1   2   3]
[4   5   6]
[7   8   9]

julia> B = HomalgMatrix([3, 5, 7, 13, 16, 19, 29, 33, 37], 3, 3, ZZ)
[ 3    5    7]
[13   16   19]
[29   33   37]

julia> L = HomalgMatrix(2:10, 3, 3, ZZ)
[2   3    4]
[5   6    7]
[8   9   10]

julia> X = SafeRightDivide(B, A, L)
[0   0   -2]
[0   0   -1]
[0   0    0]

julia> Y = HomalgMatrix([1, 3, 0, 0, 4, 0, -3, 7, 0], 3, 3, ZZ)
[ 1   3   0]
[ 0   4   0]
[-3   7   0]

julia> X*A+Y*L
[ 3    5    7]
[13   16   19]
[29   33   37]

julia> B = HomalgMatrix([3, 5, 7, 0, 16, 19, 0, 33, 37], 3, 3, ZZ)
[3    5    7]
[0   16   19]
[0   33   37]

julia> SafeRightDivide(B, A, L)
ERROR: Unable to solve linear system
```
"""
function SafeRightDivide(B, A, L)::TypeOfMatrixForHomalg
    ring = HomalgRing(A)
    nr_cols = NumberColumns(A)
    nr_rows_a = NumberRows(A)
    nr_rows_b = NumberRows(B)
    nr_rows_l = NumberRows(L)

    ident_mat_b = HomalgIdentityMatrix(nr_rows_b, ring)
    zero_mat_a = HomalgZeroMatrix(nr_rows_a, nr_rows_b, ring)
    zero_mat_l = HomalgZeroMatrix(nr_rows_l, nr_rows_b, ring)

    zero_mat_b = HomalgZeroMatrix(nr_rows_b, nr_rows_a, ring)
    ident_mat_a = HomalgIdentityMatrix(nr_rows_a, ring)
    zero_mat_l_2 = HomalgZeroMatrix(nr_rows_l, nr_rows_a, ring)

    union_rows_ident_zero = UnionOfRows(ring, nr_rows_b, [ident_mat_b, zero_mat_a, zero_mat_l])
    union_rows_zero_ident = UnionOfRows(ring, nr_rows_a, [zero_mat_b, ident_mat_a, zero_mat_l_2])
    union_rows_a_b_l = UnionOfRows(ring, nr_cols, [B, A, L])

    union_mat = UnionOfColumns(ring, nr_rows_a + nr_rows_b + nr_rows_l, [union_rows_ident_zero, union_rows_a_b_l, union_rows_zero_ident])
    
    temp_mat = RowReducedEchelonForm(union_mat)[1]
    b′ = temp_mat[1:nr_rows_b, (nr_rows_b + 1) : (nr_rows_b + nr_cols)]

    if b′ != 0
        error("Unable to solve linear system")
    end
    return -temp_mat[1:nr_rows_b, (nr_rows_b + nr_cols +1) : NumberColumns(temp_mat)]
end

"""
    RightDivide(B, A, L)

Returns: a homalg matrix or fail

Let B, A and L be matrices having the same number of columns and defined over the same ring. The matrix RightDivide( B, A, L ) is a particular solution of the inhomogeneous (one sided) linear system of equations XA+YL=B
in case it is solvable (for some Y which is forgotten). Otherwise fail is returned. The name RightDivide suggests "X=BA−1 modulo L".

```jldoctest
julia> A = HomalgMatrix(1:9, 3, 3, ZZ)
[1   2   3]
[4   5   6]
[7   8   9]

julia> B = HomalgMatrix([3, 5, 7, 13, 16, 19, 29, 33, 37], 3, 3, ZZ)
[ 3    5    7]
[13   16   19]
[29   33   37]

julia> L = HomalgMatrix(2:10, 3, 3, ZZ)
[2   3    4]
[5   6    7]
[8   9   10]

julia> X = RightDivide(B, A, L)
[0   0   -2]
[0   0   -1]
[0   0    0]

julia> B = HomalgMatrix([3, 5, 7, 0, 16, 19, 0, 33, 37], 3, 3, ZZ)
[3    5    7]
[0   16   19]
[0   33   37]

julia> RightDivide(B, A, L)
"fail"
```
"""
function RightDivide(B, A, L)::Union{TypeOfMatrixForHomalg, String}
    try
        return SafeRightDivide(B, A, L)
    catch
        return "fail"
    end
end

"""
    SafeRightDivide(B, A)

Returns: a homalg matrix

Same as RightDivide, but asserts that the result is not fail.

```jldoctest
julia> A = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> B = HomalgMatrix(3:8, 3, 2, ZZ)
[3   4]
[5   6]
[7   8]

julia> SafeRightDivide(B, A)
[0    1   0]
[0    0   1]
[0   -1   2]

julia> SafeRightDivide(A, B)
[0   3   -2]
[0   2   -1]
[0   1    0]

julia> SafeRightDivide(B, B)
[0   2   -1]
[0   1    0]
[0   0    1]

julia> B = HomalgMatrix(4:9, 3, 2, ZZ)
[4   5]
[6   7]
[8   9]

julia> SafeRightDivide(A, B)
ERROR: Unable to solve linear system
```
"""
function SafeRightDivide(B, A)::TypeOfMatrixForHomalg
    return SafeRightDivide(B, A, HomalgZeroMatrix(0, NumberColumns(A), HomalgRing(A)))
end

# function SafeRightDivide(mat2, mat1)::Union{TypeOfMatrixForHomalg}
#     return AbstractAlgebra.solve_left(mat1, mat2)
# end

"""
    UniqueRightDivide(B, A)

Returns: a homalg matrix

Same as SafeRightDivide, but asserts that the solution is unique.

```jldoctest
julia> A = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> B = HomalgMatrix(3:8, 3, 2, ZZ)
[3   4]
[5   6]
[7   8]

julia> RightDivide(B, A)
[0    1   0]
[0    0   1]
[0   -1   2]

julia> UniqueRightDivide(B, A)
ERROR: The inhomogeneous linear system of equations XA=B has no unique solution

julia> mat = HomalgIdentityMatrix(3, ZZ)
[1   0   0]
[0   1   0]
[0   0   1]

julia> UniqueRightDivide(mat, mat)
[1   0   0]
[0   1   0]
[0   0   1]
```
"""
function UniqueRightDivide(B, A)::Union{TypeOfMatrixForHomalg}

    if NumberRows(BasisOfRows(A)) != NumberRows(A)
        error("The inhomogeneous linear system of equations XA=B has no unique solution")
    end

    return SafeRightDivide(B, A)
end

"""
    RightDivide(B, A)

Returns: a homalg matrix or fail

Let B and A be matrices having the same number of columns and defined over the same ring.
The matrix RightDivide(B, A) is a particular solution of the inhomogeneous (one sided) linear system of equations XA=B in case it is solvable.
Otherwise fail is returned. The name RightDivide suggests "X=BA^-1".

```jldoctest
julia> A = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> B = HomalgMatrix(3:8, 3, 2, ZZ)
[3   4]
[5   6]
[7   8]

julia> RightDivide(B, A)
[0    1   0]
[0    0   1]
[0   -1   2]

julia> RightDivide(A, B)
[0   3   -2]
[0   2   -1]
[0   1    0]

julia> C = HomalgMatrix(4:9, 3, 2, ZZ)
[4   5]
[6   7]
[8   9]

julia> RightDivide(A, C)
"fail"

julia> RightDivide(C, A)
"fail"
```
"""
function RightDivide(B, A)::Union{TypeOfMatrixForHomalg, String}
    try
        return SafeRightDivide(B, A)
    catch
        return "fail"
    end
end

"""
    SafeLeftDivide(mat1, mat2)

Returns: a homalg matrix

Same as LeftDivide, but asserts that the result is not fail.

```jldoctest
julia> mat1 = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> mat2 = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> mat3 = HomalgMatrix([1,0,0,0,0,0], 3, 2, ZZ)
[1   0]
[0   0]
[0   0]

julia> SafeLeftDivide(mat2, mat2)
[1   0]
[0   1]

julia> SafeLeftDivide(mat1, mat2)
[0   -1]
[1    2]

julia> SafeLeftDivide(mat3, mat2)
ERROR: ArgumentError: Unable to solve linear system
```
"""
function SafeLeftDivide(mat1, mat2)::Union{TypeOfMatrixForHomalg}
    return AbstractAlgebra.solve(mat1, mat2)
end

"""
    UniqueLeftDivide(mat1, mat2)

Returns: a homalg matrix

Same as SafeLeftDivide, but asserts that the solution is unique.

```jldoctest
julia> mat1 = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> mat2 = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> UniqueLeftDivide(mat2, mat2)
[1   0]
[0   1]

julia> mat1 = HomalgMatrix([1,2,3,0,5,6,0,0,0], 3, 3, ZZ)
[1   2   3]
[0   5   6]
[0   0   0]

julia> mat2 = HomalgMatrix([1,2,0], 3, 1, ZZ)
[1]
[2]
[0]

julia> UniqueLeftDivide(mat1, mat2)
ERROR: The inhomogeneous linear system of equations mat1 X=mat2 has no unique solution
```
"""
function UniqueLeftDivide(mat1, mat2)::Union{TypeOfMatrixForHomalg}
    
    if NumberColumns(BasisOfColumns(mat1)) != NumberColumns(mat1)
        error("The inhomogeneous linear system of equations mat1 X=mat2 has no unique solution")
    end

    return SafeLeftDivide(mat1, mat2)
end

"""
    LeftDivide(mat1, mat2)

Returns: a homalg matrix or fail

Let mat1 and mat2 be matrices having the same number of rows and defined over the same ring.
The matrix LeftDivide(mat1, mat2) is a particular solution of the inhomogeneous (one sided) linear system of equations mat1X= mat2 in case it is solvable.
Otherwise fail is returned. The name LeftDivide suggests "X=mat1^{-1}mat2".

```jldoctest
julia> mat1 = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> mat2 = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> mat3 = HomalgMatrix([1,0,0,0,0,0], 3, 2, ZZ)
[1   0]
[0   0]
[0   0]

julia> LeftDivide(mat2, mat2)
[1   0]
[0   1]

julia> LeftDivide(mat1, mat2)
[0   -1]
[1    2]

julia> LeftDivide(mat3, mat2)
"fail"
```
"""
function LeftDivide(mat1, mat2)::Union{TypeOfMatrixForHomalg, String}
    try
        return AbstractAlgebra.solve(mat1, mat2)
    catch y
        return "fail"
    end
end

"""
    DecideZeroRows(mat1, mat2)

```jldoctest
julia> mat1 = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> mat2 = HomalgMatrix(2:7, 3, 2, ZZ)
[2   3]
[4   5]
[6   7]

julia> reduced_mat1 = DecideZeroRows(mat2, mat1)
[0   1]
[0   1]
[0   1]

julia> RightDivide(mat2, mat1)
"fail"

julia> RightDivide(mat2 - reduced_mat1, mat1)
[0   -1   1]
[0   -2   2]
[0   -3   3]

julia> DecideZeroRows(mat1, mat1)
[0   0]
[0   0]
[0   0]

julia> mat3 = HomalgMatrix([4, 6, 2, 2], 2, 2, ZZ)
[4   6]
[2   2]

julia> DecideZeroRows(mat3, mat1)
[0   0]
[0   0]

julia> DecideZeroRows(mat1, mat3)
[1   0]
[1   0]
[1   0]
```
"""
function DecideZeroRows(B,A)::TypeOfMatrixForHomalg
    #A,B are defined over the same ring
    ring = HomalgRing(B)

    nr_rows_A = NumberRows(A)
    nr_rows_B = NumberRows(B)

    #A,B have the same number of columns
    nr_cols = NumberColumns(B)

    null_mat_a = HomalgZeroMatrix(nr_rows_A, nr_rows_B, ring)
    ident_mat_b = HomalgIdentityMatrix(nr_rows_B, ring)

    list_of_matrices = [UnionOfRows(ring, nr_rows_B, [ident_mat_b, null_mat_a]), UnionOfRows(ring, nr_cols,[B, A])]
    temp_mat = UnionOfColumns(ring, nr_rows_B + nr_rows_A,list_of_matrices)
    resulting_mat = BasisOfRows(temp_mat)

    return resulting_mat[1:nr_rows_B, nr_rows_B+1:nr_rows_B+nr_cols]
end

"""
    DecideZeroRows(mat1, mat2)

```jldoctest
julia> mat1 = HomalgMatrix(1:6, 3, 2, ZZ)
[1   2]
[3   4]
[5   6]

julia> mat3 = HomalgMatrix([3, 1, 7, 1, 11, 1], 3, 2, ZZ)
[ 3   1]
[ 7   1]
[11   1]

julia> DecideZeroColumns(mat3, mat1)
[0   0]
[0   0]
[0   0]
```
"""
function DecideZeroColumns(B, A)::TypeOfMatrixForHomalg
    return TransposedMatrix(DecideZeroRows(TransposedMatrix(B), TransposedMatrix(A)))
end

export UnionOfRows, UnionOfColumns, KroneckerMat, CertainColumns, CertainRows,
    SafeRightDivide, UniqueRightDivide, RightDivide, SafeLeftDivide, UniqueLeftDivide, LeftDivide,
    DecideZeroRows, DecideZeroColumns

end
