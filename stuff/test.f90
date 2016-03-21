program bessel
  implicit none
  integer :: i, j, divisions, points
  double precision :: quadsum, pi, x, xmax, theta

  open(unit=1,file="data")

  pi = 3.14159265358979323846
  divisions = 5000
  points = 500
  xmax = 50

  do j = 1,points
    x = j * xmax / points
    quadsum = 0
    !$omp parallel do reduction(+:quadsum)
    do i = 0,divisions
      theta = i * pi / divisions
      if (mod(i,2) == 0) then
        quadsum = quadsum + 2 * besselKernel(1, x, theta)
      else
        quadsum = quadsum + 4 * besselKernel(1, x, theta)
      end if
    end do
    write (1,*)  x, ( besselKernel(1,x,dble(0.0)) + besselKernel(1,x,pi) + quadsum ) / (3 * divisions)
  end do
  close(1)
contains

  pure function besselKernel(j,x,theta) result(z)
    implicit none
    integer, intent(in) :: j
    double precision, intent(in) :: x
    double precision, intent(in) :: theta
    double precision :: z

    z = cos(j * theta - x * sin(theta))

  end function besselKernel

end program
