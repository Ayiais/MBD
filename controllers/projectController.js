const projectModel = require('../models/projectModel');

exports.addProject = async (req, res) => {
  try {
    const result = await projectModel.addProject(req.body);
    res.status(201).json({ message: 'Project added successfully', result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateProject = async (req, res) => {
  try {
    const result = await projectModel.updateProject(req.body);
    res.status(200).json({ message: 'Project updated successfully', result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteProjectByTitle = async (req, res) => {
  try {
    const result = await projectModel.deleteProjectByTitle(req.params.title);
    res.status(200).json({ message: 'Project deleted successfully', result });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
