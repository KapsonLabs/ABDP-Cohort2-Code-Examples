pragma solidity ^0.5.0;

library CircularBufferFIFOBytes32 {

   struct StateStruct {
     bytes32[] fifoQueue;
     uint head;
     uint tail;
     uint noOfElements;
   }

   function queueDepth(StateStruct storage self)
   internal
   view
   returns(uint elements)
   {
     return self.noOfElements;
   }

   function bufferSize(StateStruct storage self)
   internal
   view
   returns(uint length)
   {
     return self.fifoQueue.length;
   }

   function push(StateStruct storage self, bytes32 _data)
   internal
   returns(bool success)
   {
      if(self.noOfElements == self.fifoQueue.length)
      {
        self.fifoQueue.push(_data);
      }
      else
      {
        self.fifoQueue[self.tail] = _data;
      }
      incrementForPush(self);
      return true;
   }

   function pop(StateStruct storage self)
   internal
   returns(bytes32)
   {
       require(self.noOfElements>0);
       uint currentHead = self.head;
       incrementForPop(self);
       return self.fifoQueue[currentHead];
   }

   function incrementForPop(StateStruct storage self)
   internal
   {
     if(self.head + 1 == self.fifoQueue.length)
     {
       self.head = 0;
     }
     else
     {
       self.head++;
     }
     self.noOfElements--;
   }
   function incrementForPush(StateStruct storage self)
   internal
   {
     if(self.tail + 1 == self.fifoQueue.length)
     {
       self.tail = 0;
     }
     else
     {
       self.tail++;
     }
     self.noOfElements++;
   }
 }
