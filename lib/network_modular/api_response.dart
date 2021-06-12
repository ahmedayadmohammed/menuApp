class ApiResponse<T> {
  Status status;

  late T data;

 
  ApiResponse.completed(this.data) : status = Status.COMPLETED;


 
}

enum Status { LOADING, COMPLETED, ERROR }
