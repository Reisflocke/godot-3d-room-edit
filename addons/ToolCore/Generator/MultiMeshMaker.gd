tool
extends MultiMeshInstance
class_name MultiMeshMaker


func generate_meshes(mesh_data: Mesh, position_data: Array) -> MultiMesh:
	var multi_mesh = MultiMesh.new()
	multi_mesh.mesh = mesh_data
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh.instance_count = position_data.size()
	
	for i in position_data.size():
		var mesh_transform: Transform = Transform(Basis(), Vector3(position_data[i].x, 0.0, position_data[i].y))
		multi_mesh.set_instance_transform(i, mesh_transform)
	
	return multi_mesh


func generate_meshes_trans(mesh_data: Mesh, transform_data: Array):
	var multi_mesh = MultiMesh.new()
	multi_mesh.mesh = mesh_data
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh.instance_count = transform_data.size()
	
	for i in transform_data.size():
		var mesh_transform: Transform = transform_data[i]
		multi_mesh.set_instance_transform(i, mesh_transform)
	
	return multi_mesh
