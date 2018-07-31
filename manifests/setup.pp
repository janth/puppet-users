define users::setup($hash) {

  /*
  if($hash[$name]['gid']) {
    $_group = $hash[$name]['gid']
    if(!defined(Group[$name])) {
      group { $name:
        gid => $_group,
        before => User[$name],
      }
    }
  }
  */

  #if( has_key($hash[$name], 'purge_ssh_keys') and has_key($hash[$name], 'home') ) {
  if( has_key($hash[$name], 'purge_ssh_keys')  ) {
    if( has_key($hash[$name], 'home') ) {
      notice ("JTM::purge_ssh_keys and home true")
      $purge_keys = $hash[$name]['purge_ssh_keys']
      #notify { "purge_ssh_keys true": withpath => true, }
      notice ("JTM::purge_ssh_keys true")
    } else {
      notice ("JTM::purge_ssh_keys true and home false/not set")
    }
  } else {
    $purge_keys = false
    notice ("JTM::purge_ssh_keys false")
    #notify { "purge_ssh_keys false": withpath => true, }
  }
  #else { notify { "the purge_ssh_keys is false": withpath => true, } }


  if(!defined(User[$name])) {
    user { $name :
      ensure               => $hash[$name]['ensure'],
      allowdupe            => $hash[$name]['allowdupe'],
      attribute_membership => $hash[$name]['attribute_membership'],
      attributes           => $hash[$name]['attributes'],
      auth_membership      => $hash[$name]['auth_membership'],
      auths                => $hash[$name]['auths'],
      comment              => $hash[$name]['comment'],
      expiry               => $hash[$name]['expiry'],
      gid                  => $hash[$name]['gid'],
      groups               => $hash[$name]['groups'],
      home                 => $hash[$name]['home'],
      ia_load_module       => $hash[$name]['ia_load_module'],
      key_membership       => $hash[$name]['key_membership'],
      keys                 => $hash[$name]['keys'],
      managehome           => $hash[$name]['managehome'],
      membership           => $hash[$name]['membership'],
      password             => $hash[$name]['password'],
      password_max_age     => $hash[$name]['password_max_age'],
      password_min_age     => $hash[$name]['password_min_age'],
      profile_membership   => $hash[$name]['profile_membership'],
      profiles             => $hash[$name]['profiles'],
      project              => $hash[$name]['project'],
      provider             => $hash[$name]['provider'],
      role_membership      => $hash[$name]['role_membership'],
      roles                => $hash[$name]['roles'],
      shell                => $hash[$name]['shell'],
      system               => $hash[$name]['system'],
      uid                  => $hash[$name]['uid'],
      purge_ssh_keys       => $purge_keys, # Only also when home is set...
    }
  
    if($hash[$name]['ssh_authorized_keys']) {
      $_sshkey = $hash[$name]['ssh_authorized_keys']
      if(is_hash($_sshkey)) {
        $_sshkeys = keys($_sshkey)
          users::ssh_authorized_keys {
            $_sshkeys:
              hash => $_sshkey,
              user => $name,
          }
      } else {
        notify { "user ssh key data for ${name} must be in hash form": }
      }
    }
  }
}
