enum UserRole {
  admin,
  muhasebe,
  teknisyen,
}

UserRole parseRole(String? role) {
  switch ((role ?? "").toLowerCase()) {
    case "admin":
      return UserRole.admin;
    case "muhasebe":
      return UserRole.muhasebe;
    case "teknisyen":
    case "calisan": // SQL'de hâlâ calisan varsa diye GERİYE UYUMLU
      return UserRole.teknisyen;
    default:
      return UserRole.teknisyen; // güvenli varsayılan
  }
}
