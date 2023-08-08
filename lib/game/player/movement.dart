
mixin class PlayerMovement {

  double moveSpeed = 10 ;
  
  double jumpPower = 25 ;

  int accelerationX = 0;

  int accelerationY = 0;

  void idle() {
    accelerationX = 0;
  }

  void walkLeft() {
    accelerationX = -1;
  }

  void walkRight() {
    accelerationX = 1;
  }

  void jump() {
    accelerationY = 1 ;
  }


}