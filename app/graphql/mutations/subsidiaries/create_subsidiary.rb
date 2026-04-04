mutation CreateSubsidiary {
  createSubsidiary(subsidiaryInput: {name: "Example Subsidiary", statusId: 1, corporationId: 1}) {
    id
    name
    status {
      id
      name
    }
    corporation {
      id
      name
    }
  }
}
