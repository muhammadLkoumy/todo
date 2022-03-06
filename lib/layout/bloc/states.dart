abstract class TodoStates {}

class TodoInitialState extends TodoStates {}

class TodoChangeIndexState extends TodoStates {}

class TodoShowBottomSheetState extends TodoStates {}
class TodoHideBottomSheetState extends TodoStates {}

class TodoCreateDataSuccessState extends TodoStates {}

class TodoInsertDataSuccessState extends TodoStates {}

class TodoGetDataSuccessState extends TodoStates {}

class TodoUpdateDataState extends TodoStates {}

class TodoDeleteDataState extends TodoStates {}