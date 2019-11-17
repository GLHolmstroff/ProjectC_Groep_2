class ProfileConstants {
  String editUserName;
  String signOut;

  ProfileConstants(bool loggedInWithEmail){
    this.editUserName = 'Verander naam';
    this.signOut = 'Log uit';
    choices.add(editUserName);
    if(loggedInWithEmail){
      choices.add("Verander wachtwoord");
    }
    choices.add(signOut);
  }

  List<String> choices = <String>[
    
  ];
}