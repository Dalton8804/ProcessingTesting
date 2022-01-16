ArrayList<Agent> agentArr = new ArrayList<Agent>();
ArrayList<Food> foodArr = new ArrayList<Food>();

int agentDiameter = 25;
int foodDiameter = 25/2;

void setup(){
  background(0);
  size(displayWidth,displayHeight);
  frameRate(200);
}

ArrayList<Food> foodToRemove = new ArrayList<Food>();

int counter = 0;
void draw(){
  counter++;
  background(0);
  for (Food f : foodArr){
    f.render();
  }
  for (Agent a : agentArr){
    a.render();
    if(foodArr.size()>0)
      a.findFood();
    else
      if (counter%300==0)
        a.halt();
    a.move();
  }
  
  //check if any agent is touching any food
  for (Agent a: agentArr){
    a.checkCollisions();
  }
  //foodArr.add(new Food((int)random(0,width),(int)random(0,height)));
}

void mousePressed(){
  agentArr.add(new Agent(mouseX,mouseY));
}

void keyPressed(){
  foodArr.add(new Food(mouseX,mouseY));
}

boolean intersect(Agent a, Food f){
  int[] agentPos = a.getPosition();
  int[] foodPos = f.getPosition();
  float distSq = sqrt(((agentPos[0] - foodPos[0]) * (agentPos[0] - foodPos[0]))
             + ((agentPos[1] - foodPos[1]) * (agentPos[1] - foodPos[1])));
  print("\n\ndistSq: "+ distSq  );
  print("\nagent position: "+ agentPos[0]+", "+agentPos[1]);
  print("\nfood position: "+ foodPos[0]+", "+foodPos[1]);
  print("\nagent radius: "+ a.getRadius());
  
  if (distSq + (foodDiameter/2) <= a.getRadius())
    return true;
  return false;
}

class Food{
  int x;
  int y;
  Food(int a, int b){
    this.x = a;
    this.y = b;
  }
  
  void render(){
    fill(255,0,0);
    circle(this.x,this.y,foodDiameter);
  }
  int[] getPosition(){
    return new int[]{this.x,this.y};
  }
}

class Agent{
  int x=0;
  int y=0;
  int diameter = agentDiameter;
  int tarX = 0;
  int tarY = 0;
  Agent(int a, int b){
    this.x = a;
    this.y = b;
    this.tarX = (int)random(width);
    this.tarY = (int)random(height);
  }
  void updateTarget(int a, int b){
    this.tarX = a;
    this.tarY = b;
  }
  void render(){
    fill(255);
    
    circle(this.x,this.y,this.diameter);
  }
  void move(){
    if (x<tarX)
      x+=1;
    else if (x>tarX)
      x-=1;
    if (y<tarY)
      y+=1;
    else if (y>tarY)
      y-=1;
  }
  void halt(){
    this.tarX = (int)random(width);
    this.tarY = (int)random(height);
  }
  
  void findFood(){
    Food closestFood = foodArr.get(0);
    int[] foodPos = closestFood.getPosition();
    float dist = ((this.x - foodPos[0]) * (this.x - foodPos[0])
             + ((this.y - foodPos[1]) * (this.y - foodPos[1])));
    for (Food f : foodArr){
      foodPos = f.getPosition();
      float tempDist = ((this.x - foodPos[0]) * (this.x - foodPos[0]))
             + ((this.y - foodPos[1]) * (this.y - foodPos[1]));
      if (tempDist < dist){
        dist=tempDist;
        closestFood = f;
      }
    }
    foodPos = closestFood.getPosition();
    tarX = foodPos[0];
    tarY = foodPos[1];
  }
  
  void ateFood(){
    if (diameter<200)
      diameter+=10f;
  }
  
  void checkCollisions(){
    for (Food f : foodArr){
      if (intersect(this,f)) {
        foodToRemove.add(f);
        ateFood();
        break;
    }
  }
  foodArr.removeAll(foodToRemove);
  foodToRemove.clear();
  }
  
  int[] getPosition(){
    return new int[]{this.x,this.y};
  }
  int getRadius(){
    return this.diameter/2;
  }
}
