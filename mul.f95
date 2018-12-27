



program matMulProduct
   implicit none
   double complex, dimension(4,4) :: a,b,  c
   integer :: i, j, iter
    
   do i = 1, 4
      do j = 1, 4
         a(i, j) = COMPLEX(0.045,0.021)
      end do
   end do
   do i = 1, 4
      do j = 1, 4
         b(i, j) = COMPLEX(0.085,0.051)
      end do
   end do
   



!Print*, 'Matrix Multiplication: Result Matrix'
!   c= matmul(a,b)
!   call print_mat(c,4,4)
!Print*, 'Custom function'
!   a = mymatmul(a,b)
!call print_mat(a,4,4)

do i = 1,  1000000
        call expm(a,c,15)
end do
Print *, 'Done'


contains

subroutine expm(mat,mat_out,num_terms)
        implicit none
        integer , intent(in) :: num_terms
        double complex, dimension(:,:), intent(in) :: mat 

! Precalculated table for inverse factorial
        DOUBLE PRECISION,parameter :: fact(21) = [ &
1.0                    ,&
1.0                    ,&
0.5                    ,&
0.16666666666666666    ,&
0.041666666666666664   ,&
0.008333333333333333   ,&
0.001388888888888889   ,&
0.0001984126984126984  ,&
2.48015873015873e-05   ,&
2.7557319223985893e-06 ,&
2.755731922398589e-07  ,&
2.505210838544172e-08  ,&
2.08767569878681e-09   ,&
1.6059043836821613e-10 ,&
1.1470745597729725e-11 ,&
7.647163731819816e-13  ,&
4.779477332387385e-14  ,&
2.8114572543455206e-15 ,&
1.5619206968586225e-16 ,&
8.22063524662433e-18   ,&
4.110317623312165e-19  & 
]
        
        double complex, dimension(:,:),intent(inout) :: mat_out
        double complex, dimension(SIZE(mat,1),SIZE(mat,2)) :: prev
        integer :: i 
        
        prev=0.0
        do i = 1,SIZE(mat,1)
                prev(i,i)=1
        end do
        mat_out=0

        mat_out = mat_out+prev
        
        do i = 2,num_terms
        prev = matmul(prev,mat)
        mat_out=mat_out+prev*fact(i)
        end do
end subroutine

  subroutine print_mat(mat,i,j)
        integer , intent(in) :: i,j
        double complex, dimension(i,j), intent(in) :: mat       
        integer :: idx,jdx
        do idx = 1, i
                do jdx = 1, j
                Print*, mat(idx, jdx) 
                end do
        end do
 end subroutine

 function Mymatmul(a,b)
        integer :: j,i,n,k
        double complex :: tmp
        double complex,dimension(:,:) :: a,b
        double complex, dimension(size(a,1),size(a,1)) :: mymatmul
        n  = size(a,1)

     do j=1,n
         do i=1,n
            tmp = 0.0  ! enables ACC parallelism for k-loop
            do k=1,n
               tmp = tmp + a(i,k) * b(k,j)
            enddo
            mymatmul(i,j) = tmp
         enddo
      enddo
 end function



 end program 
