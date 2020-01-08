class ProfileConstants {
  String editUserName;
  String huisVerlaten;
  String signOut;

  ProfileConstants(bool loggedInWithEmail){
    this.editUserName = 'Verander naam';
    this.signOut = 'Log uit';
    this.huisVerlaten = "Verlaat je huis";
    choices.add(editUserName);
    choices.add(huisVerlaten);
    if(loggedInWithEmail){
      choices.add("Verander wachtwoord");
    }
    choices.add(signOut);
  }

  List<String> choices = <String>[
    
  ];
}